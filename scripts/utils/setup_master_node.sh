#! /bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset
# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && cd .. && pwd)"
SCRIPTS=$ROOT/scripts/utils
CRI_SOCK="/run/containerd/containerd.sock"

# Untaint master (allow pods to be scheduled on master)
echo -e "${BGreen}Removing taint from master node so pods can be scheduled there...${Color_Off}"
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
echo -e "${BGreen}Removing taint DONE${Color_Off}"

# #! Instal calico network add-on:
# echo -e "${BGreen}Deploying Calico network adapter...${Color_Off}"
# CALICO_VERSION=3.25.0
# curl --insecure --silent --show-error https://raw.githubusercontent.com/projectcalico/calico/v$CALICO_VERSION/manifests/calico.yaml -O
# kubectl apply -f calico.yaml
# echo -e "${BGreen}Calico DONE${Color_Off}"

#! Instal flannel network add-on:
echo -e "${BGreen}Deploying Flannel network adapter...${Color_Off}"
FLANNEL_VERSION=v0.21.2
kubectl apply -f kubectl apply -f https://github.com/flannel-io/flannel/releases/download/$FLANNEL_VERSION/kube-flannel.yml
echo -e "${BGreen}Flannel DONE${Color_Off}"


#! Configure cluster for metallb installation
#! Latest metallb version 13.4 does not give external IPs to LoadBalancers
# METALLB_VERSION=v0.9.4
# echo -e "${BGreen}Configuring and installing Metallb version:${Color_Off} ${METALLB_VERSION}"

# kubectl get configmap kube-proxy -n kube-system -o yaml | \
# sed -e "s/strictARP: false/strictARP: true/" | \
# kubectl apply -f - -n kube-system

# kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/$METALLB_VERSION/manifests/namespace.yaml
# kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/$METALLB_VERSION/manifests/metallb.yaml
# kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
# kubectl apply -f $ROOT/configs/metallb/metallb-configmap.yaml
# echo -e "${BGreen}Metallb DONE${Color_Off}"

echo -e "${BGreen}Configuring and installing Metallb version:${Color_Off} ${METALLB_VERSION}"
METALLB_VERSION=v0.13.9
# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/$METALLB_VERSION/config/manifests/metallb-native.yaml

kubectl apply -f $ROOT/configs/metallb/metallb-configmap.yaml
echo -e "${BGreen}Metallb DONE${Color_Off}"

#! Install and configure istio:
cd $ROOT
ISTIO_VERSION=1.17.1
echo -e "${BGreen}Installing Istio version: ${Color_Off} ${ISTIO_VERSION}"
curl --insecure --silent --show-error -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION TARGET_ARCH=x86_64 sh -
export PATH=$PATH:$ROOT/istio-$ISTIO_VERSION/bin
sudo sh -c  "echo 'export PATH=\$PATH:$ROOT/istio-${ISTIO_VERSION}/bin' >> /etc/profile"
source /etc/profile
istioctl install --set profile=default -y
echo -e "${BGreen}Istio DONE${Color_Off}"

#! Enable sidecar injection in default namespace
echo -e "${BGreen}Enabling automatic sidecar injection for default namespace...${Color_Off}"
kubectl label namespace default istio-injection=enabled --overwrite
echo -e "${BGreen}Automatic sidecar injection for default namespace DONE${Color_Off}"

$SCRIPTS/deploy_metric_services.sh