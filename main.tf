terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.2.0"
    }
  }
}

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name          = "${var.vsphere_datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_compute_cluster}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_virtual_machine_template}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

resource "vsphere_virtual_machine" "master-vm" {
  count            = var.master_node_count

  name             = "${format("${var.vsphere_virtual_machine_name}-master-%03d",count.index)}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.cpu_count
  memory           = var.memory_size
  guest_id         = "other4xLinux64Guest"
  firmware         = "efi"
  
  # ovf_deploy {
  #   // Url to remote ovf/ova file
  #   remote_ovf_url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
  # }

  
  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }


  disk {
    label = "${format("${var.vsphere_virtual_machine_name}-master-%03d-disk",count.index)}"
    size  = var.node_master_disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  
  extra_config = {
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/cloud-init/metadata.yaml", {
      hostname = "${format("${var.vsphere_virtual_machine_name}-master-%03d",count.index)}"
    }))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/cloud-init/userdata.yaml", {
      user = var.node_user
      sshpubkey = var.ssh_pubkey
    }))
    "guestinfo.userdata.encoding" = "base64"
  }
}

resource "vsphere_virtual_machine" "worker-vm" {
  count            = var.worker_node_count

  name             = "${format("${var.vsphere_virtual_machine_name}-worker-%03d",count.index)}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.cpu_count
  memory           = var.memory_size
  guest_id         = "other4xLinux64Guest"
  firmware         = "efi"
  
  # ovf_deploy {
  #   // Url to remote ovf/ova file
  #   remote_ovf_url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
  # }

  
  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }


  disk {
    label = "${format("${var.vsphere_virtual_machine_name}-worker-%03d-disk",count.index)}"
    size  = var.node_master_disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  
  extra_config = {
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/cloud-init/metadata.yaml", {
      hostname = "${format("${var.vsphere_virtual_machine_name}-worker-%03d",count.index)}"
    }))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/cloud-init/userdata.yaml", {
      user = var.node_user
      sshpubkey = var.ssh_pubkey
    }))
    "guestinfo.userdata.encoding" = "base64"
  }
}