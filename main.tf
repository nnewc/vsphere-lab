

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  allow_unverified_ssl = true
}



module "nodes" {
  source = "./modules/nodes"

  vsphere_network                  = var.vsphere_network
  vsphere_virtual_machine_name     = var.vsphere_virtual_machine_name
  vsphere_virtual_machine_template = var.vsphere_virtual_machine_template
  vsphere_password                 = var.vsphere_password
  vsphere_resource_pool            = var.vsphere_resource_pool
  vsphere_user                     = var.vsphere_user
  vsphere_server                   = var.vsphere_server
  vsphere_datacenter               = var.vsphere_datacenter
  vsphere_datastore                = var.vsphere_datastore
  vsphere_compute_cluster          = var.vsphere_compute_cluster
  vsphere_folder                   = var.vsphere_folder
  ssh_pubkey                       = var.ssh_pubkey
  ssh_user                         = var.ssh_user
  master_node_count                = var.master_node_count
  ha_controlplane                  = var.ha_controlplane
  worker_node_count                = var.worker_node_count
  registry_user                     = var.registry_user
  registry_password                 = var.registry_password
  system_default_registry          = var.system_default_registry
}

