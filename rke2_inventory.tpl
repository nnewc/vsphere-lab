[rke2_servers]
%{ for index, dns in control_node_public_dns ~}
${dns} node_ip=${control_node_private_ip[index]} node_external_ip=${control_node_public_ip[index]} node_name=${dns}  node_taints='["CriticalAddonsOnly=true:NoSchedule"]'
%{ endfor ~}

[rke2_agents]
%{ for index, dns in worker_node_public_dns ~}
${dns} node_ip=${worker_node_public_ip[index]} node_external_ip=${worker_node_public_ip[index]} node_name=${dns}
%{ endfor ~}

[rke2_cluster:children]
rke2_servers
rke2_agents

[all:vars]
ansible_ssh_user=${ansible_user}
ansible_ssh_private_key_file=${ssh_private_key}
