mkdir -p /etc/rancher/rke2

if [$HOSTNAME != ${leader}]; then
    echo "server: https://${leader_vip}:9345" >> /etc/rancher/rke2/config.yaml
fi