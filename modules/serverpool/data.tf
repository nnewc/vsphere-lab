data "cloudinit_config" "bootstrap_cloudconfig" {
  gzip          = false
  base64_encode = true

  # Main cloud-init config file
  part {
    content_type = "text/cloud-config"
    filename     = "write-files.yaml"
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
            "path": "/etc/rancher/rke2/audit.yaml",
            "content": file("${path.module}/config/rke2-audit-policy.yaml")
          },
          {
            "path": "/etc/rancher/rke2/config.yaml"
            "content": file("${path.module}/config/rke2-config.yaml")
          },
          {
            "path": "/etc/sysctl.d/90-kubelet.conf",
            "content": file("${path.module}/config/90-kubelet.conf")
          },
          {
            "path": "/etc/rancher/rke2/registries.yaml",
            "content": <<-EOT
              mirrors:
                docker.io:
                  endpoint:
                    - "https://${var.system_default_registry}"
              configs:
                "${var.system_default_registry}":
                  auth:
                    username: "${var.registry_user}"
                    password: "${var.registry_password}"
              EOT
          }
        ],
      }
    )
  }
  part {
      filename     = "base-userdata.yaml"
      content_type = "text/cloud-config"
      content = templatefile("${path.module}/cloud-init/userdata.yaml", {
        ssh_pubkey = var.ssh_pubkey
        user       = var.ssh_user
      })
    }

  part {
      content_type = "text/cloud-config"
      filename     = "rke2.yaml"
      merge_type = "list(append)+dict(recurse_array)+str()"
      content = yamlencode({
        "runcmd": [
          # "echo \"tls-san:\" >> /etc/rancher/rke2/config.yaml",
          # "echo \"- ${vsphere_virtual_machine.master-bootstrap.default_ip_address}.nip.io",
          "curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=${var.rke2_version} sh -",
          "systemctl enable rke2-server",
          "systemctl start rke2-server",
          "echo \"export KUBECONFIG=/etc/rancher/rke2/rke2.yaml\" >> /home/${var.ssh_user}/.bashrc",
          "echo \"export PATH=$PATH:/var/lib/rancher/rke2/bin\" >> /home/${var.ssh_user}/.bashrc",
          "echo \"export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml\" >> /home/${var.ssh_user}/.bashrc"
        ]
      })
    }  

  # part {
  #     filename     = "hello-script.sh"
  #     content_type = "text/x-shellscript"

  #     content = file("${path.module}/scripts/hello.sh")
  #   }
}

data "cloudinit_config" "master_cloudconfig" {
  gzip          = false
  base64_encode = true

  # Main cloud-init config file
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
            "path": "/etc/rancher/rke2/audit.yaml",
            "content": file("${path.module}/config/rke2-audit-policy.yaml")
          },
          {
            "path": "/etc/rancher/rke2/config.yaml"
            "content": file("${path.module}/config/rke2-config.yaml")
          },
          {
            "path": "/etc/sysctl.d/90-kubelet.conf",
            "content": file("${path.module}/config/90-kubelet.conf")
          },
          {
            "path": "/etc/rancher/rke2/registries.yaml",
            "content": <<-EOT
              mirrors:
                docker.io:
                  endpoint:
                    - "https://${var.system_default_registry}"
              configs:
                "${var.system_default_registry}":
                  auth:
                    username: "${var.registry_user}"
                    password: "${var.registry_password}"
            EOT
          }
        ],
      }
    )
  }
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
      merge_type = "list(append)+dict(recurse_array)+str()"
      content = yamlencode({
        "runcmd": [
          "echo \"server: https://${vsphere_virtual_machine.master-bootstrap.default_ip_address}:9345\" >> /etc/rancher/rke2/config.yaml",
          "curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=${var.rke2_version} sh -",
          "systemctl enable rke2-server",
          "systemctl start rke2-server",
          "echo \"export KUBECONFIG=/etc/rancher/rke2/rke2.yaml\" >> /home/${var.ssh_user}/.bashrc",
          "echo \"export PATH=$PATH:/var/lib/rancher/rke2/bin\" >> /home/${var.ssh_user}/.bashrc",
          "echo \"export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml\" >> /home/${var.ssh_user}/.bashrc"
        ]})
    }

    # part {
    #   filename     = "hello-script.sh"
    #   content_type = "text/x-shellscript"

    #   content = file("${path.module}/scripts/hello.sh")
    # }
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
    })
  }

  part {
    filename = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = yamlencode({
      "write_files":[{
        "path": "/etc/rancher/rke2/config.yaml",
        "content": <<-EOT
          token: i-am-a-token
          server: https://${vsphere_virtual_machine.master-bootstrap.default_ip_address}:9345
          write-kubeconfig-mode: 0640
          profile: cis-1.6
          kube-apiserver-arg:
          - authorization-mode=RBAC,Node
          kubelet-arg:
          - protect-kernel-defaults=true
          - read-only-port=0
          - authorization-mode=Webhook
          EOT
      },
      {
        "path": "/etc/sysctl.d/90-kubelet.conf",
        "content": file("${path.module}/config/90-kubelet.conf")
      },
      {
          "path": "/etc/rancher/rke2/registries.yaml",
          "content": <<-EOT
          mirrors:
            docker.io:
              endpoint:
              - "https://${var.system_default_registry}"
          configs:
            "${var.system_default_registry}":
              auth:
                username: "${var.registry_user}"
                password: "${var.registry_password}"
          EOT
          }
      ] 
    })
  }

  part {
      content_type = "text/cloud-config"
      filename     = "cloud.yaml"
      merge_type = "list(append)+dict(recurse_array)+str()"
      content = yamlencode({
        "runcmd": [
          "sysctl -p /etc/sysctl.d/90-kubelet.conf",
          "curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=agent INSTALL_RKE2_VERSION=${var.rke2_version} sh -",
          "systemctl enable rke2-agent",
          "systemctl start rke2-agent",
          "mkdir /home/${var.ssh_user}/kube",
          # configure bash environment
          "echo \"export KUBECONFIG=/etc/rancher/rke2/rke2.yaml\" >> /home/${var.ssh_user}/.bashrc",
          "echo \"export PATH=$PATH:/var/lib/rancher/rke2/bin\" >> /home/${var.ssh_user}/.bashrc",
          "echo \"export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml\" >> /home/${var.ssh_user}/.bashrc",
          # set selinux context for istio-cni
          "mkdir -p /var/run/istio-cni && semanage fcontext -a -t container_file_t /var/run/istio-cni && restorecon -v /var/run/istio-cni"
        ]})
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