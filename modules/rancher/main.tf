terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "4.0.0"
    }
  }
}



provider "rancher2" {
  alias = "admin"
  api_url = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure = true
}


resource "rancher2_catalog_v2" "rgs-carbide" {
  cluster_id = "local"
  provider = rancher2.admin
  name = "rgs-carbide"
  url = var.carbide_charts_url
}
