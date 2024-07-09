resource "rancher2_machine_config_v2" "vsphere-nodes-cp" {
  provider = rancher2.admin
  generate_name = "foo-harvester-v2"
  vsphere_config {
    cfgparam       = ["disk.enableUUID=TRUE"] # Disk UUID is Required for vSphere Storage Provider
    clone_from     = data.vsphere_virtual_machine.template.name
    cloud_config   = var.cloud_config
    cpu_count      = var.cpu_count
    creation_type  = "template"
    datacenter     = data.vsphere_datacenter.datacenter.name
    datastore      = data.vsphere_datastore.datastore.name
    disk_size      = var.disk_size
    folder         = var.vsphere_folder
    memory_size    = var.memory_size
    network        = ["${var.vsphere_network}"]
    pool           = var.resource_pool
    vapp_transport = var.vapp_transport
    vapp_property  = var.vapp_property
    vapp_ip_allocation_policy = "dhcp"
    vapp_ip_protocol          = var.vapp_ip_protocol
    ssh_user       = var.ssh_user
    ssh_password = var.ssh_password
  }
}

resource "rancher2_machine_config_v2" "vsphere-nodes-workers" {
  provider = rancher2.admin
  generate_name = "foo-harvester-v2"
  vsphere_config {
    cfgparam       = ["disk.enableUUID=TRUE"] # Disk UUID is Required for vSphere Storage Provider
    clone_from     = data.vsphere_virtual_machine.template.name
    cloud_config   = var.cloud_config
    cpu_count      = var.cpu_count
    creation_type  = "template"
    datacenter     = data.vsphere_datacenter.datacenter.name
    datastore      = data.vsphere_datastore.datastore.name
    disk_size      = var.disk_size
    folder         = var.vsphere_folder
    memory_size    = var.memory_size
    network        = ["${var.vsphere_network}"]
    pool           = var.resource_pool
    vapp_transport = var.vapp_transport
    vapp_property  = var.vapp_property
    vapp_ip_allocation_policy = "dhcp"
    vapp_ip_protocol          = var.vapp_ip_protocol
    ssh_user       = var.ssh_user 
    ssh_password = var.ssh_password
  }
}


resource "rancher2_cluster_v2" "cluster" {
    provider = rancher2.admin
    name = var.cluster_name
    kubernetes_version = var.kubernetes_version
    rke_config {
      # Nodes in this pool have control plane role and etcd roles
      machine_pools {
        name = "cp-nodes"
        cloud_credential_secret_name = data.rancher2_cloud_credential.vsphere_creds.id
        control_plane_role = true
        etcd_role = true
        worker_role = false
        quantity = 3
        drain_before_delete = true
        machine_config {
          kind = rancher2_machine_config_v2.vsphere-nodes-cp.kind
          name = rancher2_machine_config_v2.vsphere-nodes-cp.name
        }
    }

    machine_pools {
      name = "worker-nodes"
      cloud_credential_secret_name = data.rancher2_cloud_credential.vsphere_creds.id
      control_plane_role = false
      etcd_role = false
      worker_role = true
      quantity = 2
      drain_before_delete = true
      machine_config {
        kind = rancher2_machine_config_v2.vsphere-nodes-workers.kind
        name = rancher2_machine_config_v2.vsphere-nodes-workers.name
      }
    }
  }
}