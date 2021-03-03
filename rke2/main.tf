data "digitalocean_ssh_key" "ondrejsika" {
  name = var.ssh_key_name
}

resource "digitalocean_droplet" "nodes" {
  count = var.node_count

  image     = "docker-18-04"
  name      = "cloud-talks-rke2-${count.index}"
  region    = "fra1"
  size      = "s-2vcpu-4gb"
  ssh_keys  = [data.digitalocean_ssh_key.ondrejsika.id]
  tags      = ["k8s-rke"]
  user_data = <<-EOT
    #!/bin/sh
    ufw disable
  EOT
}

resource "cloudflare_record" "nodes" {
  count = var.node_count

  zone_id = var.cloudflare_zone_id
  name    = digitalocean_droplet.nodes[count.index].name
  value   = digitalocean_droplet.nodes[count.index].ipv4_address
  type    = "A"
  proxied = false
}

resource "rke_cluster" "main" {
  cluster_name   = "cloud-talks-rke2"
  ssh_agent_auth = true
  dynamic "nodes" {
    for_each = digitalocean_droplet.nodes
    content {
      hostname_override = nodes.value["name"]
      address           = nodes.value["ipv4_address"]
      user              = "root"
      role              = ["controlplane", "etcd", "worker"]
    }
  }
}

output "kubeconfig" {
  value     = rke_cluster.main.kube_config_yaml
  sensitive = true
}
