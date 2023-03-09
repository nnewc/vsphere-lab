
data "cloudinit_config" "this" {
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
    filename     = "00_download.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/scripts/download.sh", {
      # Must not use `version` here since that is reserved
      rke2_version = var.rke2_version
      type         = "server"
    })
  }

  #   part {
  #     filename     = "01_rke2.sh"
  #     content_type = "text/x-shellscript"
  #     content      = module.init.templated
  #   }
}
