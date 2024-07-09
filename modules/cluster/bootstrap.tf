# provider "rancher2" {
#   alias = "bootstrap"
#   api_url   = var.rancher_api_url
#   bootstrap = true
#   insecure = true
# }

# resource "rancher2_bootstrap" "admin" {
#   provider = rancher2.bootstrap
#   #initial_password = "KUqm@9u$GgH9&z*Mjj@r"
#   password = var.rancher_admin_password
#   telemetry = true
# }