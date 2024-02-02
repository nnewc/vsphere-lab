provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_filepath
  }
 # private registry
  registry {
    url = "oci://rgcrprod.azurecr.us"
    username = var.registry_user
    password = var.registry_password
  }
}

resource "helm_release" "cert-manager" {
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
  version           = var.rancher_version

  set {
    name  = "hostname"
    value = var.rancher_server
  }

  set {
    name  = "global.cattle.psp.enabled"
    value = "true"
  }

  set {
    name  = "systemDefaultRegistry"
    value = var.system_default_registry
  }

  set {
    name = "bootstrapPassword"
    value = "admin"
  }

}