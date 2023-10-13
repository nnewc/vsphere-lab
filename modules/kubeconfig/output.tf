output "filepath" {
   value = local_sensitive_file.kubeconfig_file.filename
}

output "kubeconfig_content" {
  value = local_sensitive_file.kubeconfig_file.content
}