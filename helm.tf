provider "helm" {
  kubernetes {
    config_path = module.kubeconfig.filepath
  }
 # private registry
  registry {
    url = "oci://rgcrprod.azurecr.us"
    username = var.registry_user
    password = var.registry_password
  }
}

module "kubeconfig" {
  source = "./modules/kubeconfig"
  ssh_host = module.nodes.bootstrap-ip
  ssh_user = var.ssh_user
}

resource "helm_release" "cert-manager" {
  depends_on = [ module.nodes ]
  name       = "cert-manager"

  repository        = "https://charts.jetstack.io"
  chart             = "cert-manager"
  version           = "1.7.3"
  namespace         = "cert-manager"
  create_namespace  = "true"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "rancher" {
  depends_on = [ helm_release.cert-manager ]
  name       = "rancher"

  repository        = "https://releases.rancher.com/server-charts/stable"
  chart             = "rancher"
  #version           = ""
  namespace         = "cattle-system"
  create_namespace  = "true"

  set {
    name  = "hostname"
    value = "${module.nodes.worker-ip[0]}.nip.io"
  }

  set {
    name  = "global.cattle.psp.enabled"
    value = "true"
  }

  set {
    name  = "systemDefaultRegistry"
    value = "${var.system_default_registry}"
  }

}