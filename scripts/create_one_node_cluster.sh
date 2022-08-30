#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts
CRI_SOCK="/run/containerd/containerd.sock"

#! kubeadm init:
sudo kubeadm init --ignore-preflight-errors=all --cri-socket $CRI_SOCK --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# if the user is root, export KUBECONFIG as $HOME is different for root user and /etc is readable
if [ "$EUID" -eq 0 ]; then
    export KUBECONFIG=/etc/kubernetes/admin.conf
fi


# Untaint master (allow pods to be scheduled on master)
kubectl taint nodes --all node-role.kubernetes.io/master-

#! Setup for master node:
$SCRIPTS/setup_master_node.sh