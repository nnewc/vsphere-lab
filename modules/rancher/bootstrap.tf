provider "rancher2" {
  alias = "bootstrap"
  api_url   = var.rancher_api_url
  bootstrap = true
  insecure = true
}

resource "rancher2_bootstrap" "admin" {
  depends_on = [ helm_release.rancher ]
  provider = rancher2.bootstrap
  initial_password = "admin"
  password = var.rancher_admin_password
  telemetry = true
}