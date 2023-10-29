output "bootstrap-ip" {
   value = "${vsphere_virtual_machine.master-bootstrap.default_ip_address}"
}

output "worker-ip" {
   value = "${vsphere_virtual_machine.worker-vm.*.default_ip_address}"
}

output "ingress-ip" {
   value = "${module.nodes.worker-ip[0]}.nip.io"
}

# output "leader-ip" {
#    value = "${vsphere_virtual_machine.master-vm[0].default_ip_address}"
# }

# output "userdata" {
#    value = "${data.cloudinit_config.master_cloudconfig}"
# }