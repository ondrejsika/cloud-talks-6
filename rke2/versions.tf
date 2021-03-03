terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.18.0"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.1.7"
    }
  }
  required_version = ">= 0.13"
}
