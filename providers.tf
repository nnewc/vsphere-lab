terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.5.0"
    }

     ssh = {
      source  = "loafoe/ssh"
      version = "2.6.0"
    }
  }
}