#!/bin/sh
echo "Hello World! I'm starting up now at $(date -R)!"

# install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# install Helm repos
helm repo add jetstack https://charts.jetstack.io
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

# install cert-manager
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true --version 1.9

# install Rancher
helm install rancher rancher-stable/rancher --namespace cattle-system --create-namespace --set replicas=1  && kubectl -n cattle-system rollout status deploy/rancher