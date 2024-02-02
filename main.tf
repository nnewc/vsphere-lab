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
  registry_user                    = var.registry_user
  registry_password                = var.registry_password
  system_default_registry          = var.system_default_registry
  rke2_channel                     = var.rke2_channel
  rke2_version                     = var.rke2_version
}

module "kubeconfig" {
  source = "./modules/kubeconfig"
  ssh_host = module.nodes.bootstrap-ip
  ssh_user = var.ssh_user
}

module "rancher" {
  source = "./modules/rancher"
  rancher_api_url = "https://${module.nodes.ingress-ip}.nip.io"
  rancher_server = "${module.nodes.ingress-ip}.nip.io"
  rancher_admin_password = var.rancher_admin_password
  insecure_api = true
  registry_user = var.registry_user
  registry_password = var.registry_password
  kubeconfig_filepath = module.kubeconfig.filepath
}
