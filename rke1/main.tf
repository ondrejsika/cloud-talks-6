data "digitalocean_ssh_key" "ondrejsika" {
  name = var.ssh_key_name
}

resource "digitalocean_droplet" "nodes" {
  count = var.node_count

  image     = "docker-18-04"
  name      = "cloud-talks-rke1-${count.index}"
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
