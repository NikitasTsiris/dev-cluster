#! /bin/bash

sudo apt-get update >> /dev/null

#! Install containerd and runc
sudo apt-get -y install btrfs-progs pkg-config libseccomp-dev unzip tar libseccomp2 socat util-linux apt-transport-https curl ipvsadm >> /dev/null
sudo apt-get -y install apparmor apparmor-utils >> /dev/null        # needed for containerd versions >1.5.x

wget --continue --quiet https://github.com/containerd/containerd/releases/download/v1.6.8/containerd-1.6.8-linux-amd64.tar.gz
sudo tar Czxvf /usr/local -xzf containerd-1.6.8-linux-amd64.tar.gz

wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv containerd.service /usr/lib/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable --now containerd

wget --continue --quiet https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
mv runc.amd64 runc
sudo install -D -m0755 runc /usr/local/sbin/runc

containerd --version || echo "failed to build containerd"

#! Install K8s
K8S_VERSION=1.24.3-00
curl --silent --show-error https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list"
sudo apt-get update >> /dev/null
sudo apt-get -y install cri-tools ebtables ethtool kubeadm=$K8S_VERSION kubectl=$K8S_VERSION kubelet=$K8S_VERSION kubernetes-cni >> /dev/null

# Necessary for containerd as container runtime but not docker
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo systemctl restart containerd