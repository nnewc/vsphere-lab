terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "4.1.0"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.5.0"
    }
  }
}

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

provider "rancher2" {
  alias = "admin"
  api_url = var.rancher_api_url
  insecure = true
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}