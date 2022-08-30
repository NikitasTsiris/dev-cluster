#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts
CRI_SOCK="/run/containerd/containerd.sock"

#! Instal calico network add-on:
curl https://docs.projectcalico.org/manifests/calico.yaml -O

kubectl apply -f calico.yaml

#! Configure cluster for metallb installation
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

#! Install metallb
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.4/config/manifests/metallb-native.yaml
kubectl apply -f $ROOT/configs/metallb/metallb-configmap.yaml

# Install and configure istio:
cd $ROOT
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.14.3 TARGET_ARCH=x86_64 sh -
export PATH=$PATH:$ROOT/istio-1.14.3/bin
sudo sh -c  "echo 'export PATH=\$PATH:$ROOT/istio-1.14.3/bin' >> /etc/profile"
istioctl install