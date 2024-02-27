output "bootstrap-ip" {
   value = "${vsphere_virtual_machine.master-bootstrap.default_ip_address}"
}

output "worker-ip" {
   value = "${vsphere_virtual_machine.worker-vm.*.default_ip_address}"
}

output "ingress-ip" {
   value = "${vsphere_virtual_machine.worker-vm[0].default_ip_address}"
}

output "controlplane-endpoint" {
  value = "https://${var.kubevip_vip_address}.nip.io:6443"
}

output "ingress-endpoint" {
  value = "${var.kubevip_vip_address}"
}

# output "leader-ip" {
#    value = "${vsphere_virtual_machine.master-vm[0].default_ip_address}"
# }

# output "userdata" {
#    value = "${data.cloudinit_config.master_cloudconfig}"
# }