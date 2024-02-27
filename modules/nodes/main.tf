
locals {
  cluster-name = "vsphere-lab"
  bootstrap_vm_name = "${var.vsphere_virtual_machine_name}-master-000"
}

resource "vsphere_virtual_machine" "master-bootstrap" {
  
  name             = local.bootstrap_vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder
  num_cpus         = var.cpu_count
  memory           = var.memory_size
  memory_hot_add_enabled = true
  guest_id         = "other5xLinux64Guest"
  firmware         = "efi"
  
  # ovf_deploy {
  #   // Url to remote ovf/ova file
  #   remote_ovf_url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
  # }

  provisioner "remote-exec" {
    
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
    
    connection {
      type        = "ssh"
      host        = self.default_ip_address
      user        = var.ssh_user
      certificate = var.ssh_pubkey
      agent       = true
      script_path = "/home/${var.ssh_user}/user-data-check.sh"
    }
  }
  
  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }


  disk {
    label = local.bootstrap_vm_name
    size  = var.node_master_disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  
  extra_config = {
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/cloud-init/metadata.yaml", {
      hostname = "${local.bootstrap_vm_name}"
    }))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = "${data.cloudinit_config.bootstrap_cloudconfig.rendered}"
    "guestinfo.userdata.encoding" = "base64"
  }

  # workaround for this isssue: https://github.com/hashicorp/terraform-provider-vsphere/issues/1902
  lifecycle {
    ignore_changes = [
      ept_rvi_mode,
      hv_mode
    ]
  }
}


resource "vsphere_virtual_machine" "master_nodes" {
  
  depends_on = [
    vsphere_virtual_machine.master-bootstrap
  ]


  count            = var.ha_controlplane ? 2 : 0

  name             = "${format("${var.vsphere_virtual_machine_name}-master-%03d",count.index + 1)}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder
  num_cpus         = var.cpu_count
  memory           = var.memory_size
  memory_hot_add_enabled = true
  guest_id         = "other5xLinux64Guest"
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
    label = "${format("${var.vsphere_virtual_machine_name}-master-%03d-disk",count.index + 1)}"
    size  = var.node_master_disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  
  extra_config = {
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/cloud-init/metadata.yaml", {
      hostname = "${format("${var.vsphere_virtual_machine_name}-master-%03d",count.index + 1)}"
    }))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = "${data.cloudinit_config.master_cloudconfig[count.index].rendered}"
    "guestinfo.userdata.encoding" = "base64"
  }

  # workaround for this isssue: https://github.com/hashicorp/terraform-provider-vsphere/issues/1902
  lifecycle {
    ignore_changes = [
      ept_rvi_mode,
      hv_mode
    ]
  }
}

resource "vsphere_virtual_machine" "worker-vm" {
  depends_on = [ vsphere_virtual_machine.master-bootstrap ]

  count            = var.worker_node_count

  name             = "${format("${var.vsphere_virtual_machine_name}-worker-%03d",count.index)}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder
  num_cpus         = var.cpu_count
  memory           = var.memory_size
  memory_hot_add_enabled = true
  guest_id         = "other5xLinux64Guest"
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
    "guestinfo.userdata"          = "${data.cloudinit_config.worker_cloudconfig[count.index].rendered}"
    "guestinfo.userdata.encoding" = "base64"
  }

  # workaround for this isssue: https://github.com/hashicorp/terraform-provider-vsphere/issues/1902
  lifecycle {
    ignore_changes = [
      ept_rvi_mode,
      hv_mode
    ]
  }

  provisioner "remote-exec" {
    
    inline = [
      "cloud-init status --wait > /dev/null",
      #"until $(curl --output /dev/null --silent --head --fail http://${var.kubevip_vip_address}/healthz); do printf '.'; sleep 5; done"
    ]
    
    connection {
      type        = "ssh"
      host        = self.default_ip_address
      user        = var.ssh_user
      certificate = var.ssh_pubkey
      agent       = true
      script_path = "/home/${var.ssh_user}/user-data-check.sh"
    }
  }
}
