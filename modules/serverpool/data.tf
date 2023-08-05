data "cloudinit_config" "master_cloudconfig" {
  gzip          = false
  base64_encode = false

  # Main cloud-init config file
  # part {
  #   filename     = "cloud-config.yaml"
  #   content_type = "text/cloud-config"
  #   content = templatefile("${path.module}/cloud-init/userdata.yaml", {
  #     ssh_pubkey = var.ssh_pubkey
  #     user       = var.ssh_user
  #     rke2-audit = file("${path.module}/config/rke2-audit-policy.yaml")
  #     rke2-config = file("${path.module}/config/rke2-config.yaml")
  #   })
  # }


  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content = yamlencode(
      {

        "write_files" : [
          # {
          #   "path" : "/etc/foo.conf",
          #   "content" : "foo contents",
          # },
          # {
          #   "path" : "/etc/bar.conf",
          #   "content" : file("bar.conf"),
          # },
          {
            "path": "/etc/rancher/rke2/audit.yaml",
            "content": file("${path.module}/config/rke2-audit-policy.yaml")
          },
          {
            "path": "/etc/rancher/rke2/config.yaml"
            "content": file("${path.module}/config/rke2-config.yaml")
          },
          # {
          #   "path" : "/etc/baz.conf",
          #   "content" : templatefile("baz.tpl.conf", { SOME_VAR = "qux" }),
          # },
        ],
      }
    )
  }

  # part {
  #   filename     = "00_download.sh"
  #   content_type = "text/x-shellscript"
  #   content = templatefile("${path.module}/scripts/download.sh", {
  #     # Must not use `version` here since that is reserved
  #     rke2_version = var.rke2_version
  #     type         = "server"
  #   })
  # }

  #   part {
  #     filename     = "01_rke2.sh"
  #     content_type = "text/x-shellscript"
  #     content      = module.init.templated
  #   }
}


data "cloudinit_config" "worker_cloudconfig" {
  gzip          = false
  base64_encode = true

  # Main cloud-init config file
  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/userdata.yaml", {
      ssh_pubkey = var.ssh_pubkey
      user       = var.ssh_user
      rke2-audit = ""
      rke2-config = templatefile("${path.module}/config/rke2-config.yaml", {})
    })
  }

  # part {
  #   filename     = "00_download.sh"
  #   content_type = "text/x-shellscript"
  #   content = templatefile("${path.module}/scripts/download.sh", {
  #     # Must not use `version` here since that is reserved
  #     rke2_version = var.rke2_version
  #     type         = "agent"
  #   })
  # }

  #   part {
  #     filename     = "01_rke2.sh"
  #     content_type = "text/x-shellscript"
  #     content      = module.init.templated
  #   }
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