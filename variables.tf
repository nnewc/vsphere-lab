variable "vsphere_datacenter" {
  type = string
  default = ""
}

variable "vsphere_compute_cluster" {
  type = string
  default = ""
}

variable "vsphere_datastore" {
  type = string
  default = "####"
}

variable "cluster_name" {
  type = string
  default = "my-cluster"
}

variable "cpu_count" {
  type = number
  default = 4
  description = "number of CPUs on cluster nodes"
}

variable "memory_size" {
  type = number
  description = "size of memory on cluster nodes"
}

variable "node_master_disk_size" {
  description = "size of disk on master nodes in GB"
  type = number
  default = 40
}

variable "node_worker_disk_size" {
  description = "size of disk on master nodes in GB"
  type = number
  default = 60
}

variable "master_node_count" {
  description = "number of master nodes to create in the cluster"
  type = number
  default = 1
}

variable "ha_controlplane" {
  description = "flag to enable a highly-available control plane (3 nodes)"
  type = bool
  default = false
}

variable "worker_node_count" {
  description = "worker of master nodes to create in the cluster"
  type = number
  default = 1
}

variable "clone_from" {
  type = string
  default = ""
}

variable "rke2_version" {
  type = string
  default = ""
}

variable "rke2_channel" {
  type = string
  default = ""
}

variable "vm_template_name" {
  type = string
  default = ""
}

variable "ssh_user" {
  type = string
  default = ""
}

variable "ssh_password" {
  type = string
  default= ""
}

variable "vsphere_user" {
  default = "administrator@vsphere.local"
}

# vsphere account password. empty by default.
variable "vsphere_password" {
  type = string
}

# vsphere server, defaults to localhost
variable "vsphere_server" {
  default = "localhost"
  type = string
  description = "url of vsphere server"
}

# vsphere resource pool the virtual machine will be deployed to. empty by default.
variable "vsphere_resource_pool" {}

# vsphere network the virtual machine will be connected to. empty by default.
variable "vsphere_network" {}

variable "vsphere_virtual_machine_template" {
  type = string
  description = "vsphere virtual machine template that the virtual machine will be cloned from. empty by default."
}

variable "vsphere_folder" {
  type = string
  default = ""
}

# the name of the vsphere virtual machine that is created. empty by default.
variable "vsphere_virtual_machine_name" {}

variable "node_template_hostprefix_master" {
  description = "master node hostname prefix"
  type = string
  default = "master"
}

variable "node_template_hostprefix_worker" {
  description = "worker node hostname prefix"
  type = string
  default = "worker"
}

variable "ubuntu_packages" {
  description = "apt packages installed on all nodes"
  type    = list
  default = []
}

variable "ssh_pubkey" {
  description = "ssh key to be added to authorized_keys on all cluster nodes"
  type = string
  default = ""
}

variable "download" {
  description = "Toggle best effort download of rke2 dependencies, if disabled, dependencies are assumed to exist in $PATH"
  type        = bool
  default     = true
}

# variable "node_user" {
#   description = "default user to log in to nodes"
#   type = string
# }

variable "kubevip_ip" {
  description = "kube-vip virtual IP address (VIP)"
  type = string
  default = ""
}

variable "registry_user" {
  type = string
  default = ""
}

variable "registry_password" {
  type = string
  default = ""
}

variable "system_default_registry" {
  type = string
  default = ""
}

variable "rancher_admin_password" {
  type = string
  default = ""
}

variable "rancher_server" {
  type = string
  default = ""
}

variable "rancher_version" {
  type = string
  default = ""
}