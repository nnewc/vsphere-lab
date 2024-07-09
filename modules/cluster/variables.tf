variable "rancher_api_url" {
    type = string
    default = ""
}

variable "rancher_access_key" {
    type = string
    default = ""
}

variable "rancher_secret_key" {
    type = string
    default = ""
    sensitive = true
}

variable "rancher_admin_password" {
  type = string
  default = ""
}

variable "cluster_name" {
  type = string
  default = ""
}

variable "kubernetes_version" {
  type = string
  default = ""
}

variable "cpu_count" {
  description = "Number of CPUs to assign to node"
  type        = number
  default     = 4
}

variable "creation_type" {
  description = "Creation type when creating a new virtual machine. Supported values: vm, template, library, legacy."
  type        = string
  default     = ""
}

variable "datacenter_name" {
  description = "Name of vSphere Datacenter to deploy nodes"
  type        = string
  default     = ""
}

variable "datastore_name" {
  description = "Name of vSphere Datastore to write nodes"
  type        = string
  default     = ""
}

variable "disk_size" {
  description = "Size (in GB) to assign to nodes volume"
  type        = number
  default     = 100
}

variable "vsphere_folder" {
  description = "Folder VM should be created into"
  type        = string
  default     = ""
}

variable "memory_size" {
  description = "Amount of RAM (in MB) to assign to node"
  type        = number
  default     = 4096
}

variable "network_name" {
  description = "Name of vSphere network to attach to nodes"
  type        = list(string)
  default     = [ "" ]
}

variable "resource_pool" {
  description = "Name of vSphere resource pool to store VMs"
  type        = string
  default     = ""
}

variable "vapp_property" {
  description = "vApp Properties, used to pass in static IP information"
  type        = list(string)
  default     = [ "" ]
}

variable "vapp_transport" {
  description = "OVF environment transports to use for properties. Supported values are: iso and com.vmware.guestInfo"
  type        = string
  default     = null
}

variable "vapp_ip_allocation_policy" {
  description = "vSphere vApp IP allocation policy. Supported values are: dhcp, fixed, transient and fixedAllocated"
  type        = string
  default     = ""
}

variable "vapp_ip_protocol" {
  description = "vSphere vApp IP protocol for this deployment. Supported values are: IPv4 and IPv6"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels applied to nodes in the pool"
  type        = map(string)
  default     = {}
}

## Node Pool Settings / vSphere Config
variable "cfgparam" {
  description = "vSphere Configuration Parameters"
  type        = list(string)
  default     = [ "disk.enableUUID=TRUE" ]
}

variable "clone_from" {
  description = "If cloning from a VM, the name of the template"
  type        = string
  default     = ""
}

variable "cloud_config" {
    default = ""
    type = string
}

variable "ssh_user" {
    default = ""
    type = string
}

variable "ssh_password" {
    default = ""
    type = string
}

variable "vsphere_user" {
  default = ""
  type = string
}

variable "vsphere_password" {
  default = ""
  type = string
}

variable "vsphere_server" {
  default = ""
  type = string
}

variable "vsphere_datacenter" {
  default = ""
  type = string
}

variable "vsphere_datastore" {
  default = ""
  type = string
}

variable "vsphere_compute_cluster" {
  default = ""
  type = string
}

variable "vsphere_network" {
  default = ""
  type = string
}

variable "vsphere_virtual_machine_template" {
  default = ""
  type = string
}
