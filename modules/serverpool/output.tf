output "master-ip" {
   value = "${vsphere_virtual_machine.master-bootstrap.default_ip_address}"
}

output "worker-ip" {
   value = "${vsphere_virtual_machine.worker-vm.*.default_ip_address}"
}

# output "leader-ip" {
#    value = "${vsphere_virtual_machine.master-vm[0].default_ip_address}"
# }

# output "userdata" {
#    value = "${data.cloudinit_config.master_cloudconfig}"
# }