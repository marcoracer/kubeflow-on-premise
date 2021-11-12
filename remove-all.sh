#!/bin/bash

echo "[INFO] - Reseting kubeadm"
sudo kubeadm reset
if systemctl is-active --quiet kubelet; then
  echo "[INFO] - Stoping kubelet service"
  sudo systemctl stop kubelet
fi
if systemctl is-active --quiet docker; then
  echo "[INFO] - Stopping docker service"
  sudo systemctl stop docker
fi
echo "[INFO] - Removing kubelet, kubectl, kubeadm, kubernetes-cni and docker-ce"
sudo apt-get purge kubelet kubectl kubeadm kubernetes-cni
sudo apt-get purge docker-ce
sudo apt-get purge docker.io
echo "[INFO] - Removing Kubernetes files configuration"
sudo rm -rf /etc/kubernetes/ /var/lib/etcd /var/lib/kubelet /var/lib/dockershim /var/run/kubernetes /var/lib/cni ~/.kube /opt/k8s-kfhom
