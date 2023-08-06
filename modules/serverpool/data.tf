data "cloudinit_config" "master_cloudconfig" {
  gzip          = false
  base64_encode = true

  # Main cloud-init config file
  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/userdata.yaml", {
      ssh_pubkey = var.ssh_pubkey
      user       = var.ssh_user
    })
  }


  part {
    content_type = "text/cloud-config"
    filename     = "cloud.yaml"
    content = yamlencode(
      {
        "write_files" : [
          # write_files examples...
          # {
          #   "path" : "/etc/foo.conf",
          #   "content" : "foo contents",
          # },
          # {
          #   "path" : "/etc/bar.conf",
          #   "content" : file("bar.conf"),
          # },
          # {
          #   "path" : "/etc/baz.conf",
          #   "content" : templatefile("baz.tpl.conf", { SOME_VAR = "qux" }),
          # },
          {
            "path": "/etc/sysctl.d/99-kubeletSettings.conf",
            "content": <<EOT
              kernel.panic = 10
              kernel.panic_on_oops = 1
              kernel.panic_ps = 1
              vm.overcommit_memory = 1
              vm.panic_on_oom = 0
            EOT
          }
          {
            "path": "/etc/rancher/rke2/audit.yaml",
            "content": file("${path.module}/config/rke2-audit-policy.yaml")
          },
          {
            "path": "/etc/rancher/rke2/config.yaml"
            "content": file("${path.module}/config/rke2-config.yaml")
          }
        ],
      }
    )
  }
  part {
    filename     = "hello-script.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/scripts/hello.sh")
  }
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