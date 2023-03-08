output "master-ip" {
   value = "${vsphere_virtual_machine.master-vm.*.default_ip_address}"
}

output "worker-ip" {
   value = "${vsphere_virtual_machine.worker-vm.*.default_ip_address}"
}
