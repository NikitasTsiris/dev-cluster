#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts
CRI_SOCK="/run/containerd/containerd.sock"


# Untaint master (allow pods to be scheduled on master)
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
#! Instal calico network add-on:
curl https://docs.projectcalico.org/manifests/calico.yaml -O

kubectl apply -f calico.yaml

#! Configure cluster for metallb installation
#! Latest metallb version 13.4 does not give external IPs to LoadBalancers
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.4/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.4/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f $ROOT/configs/metallb/metallb-configmap.yaml

#! Install and configure istio:
cd $ROOT
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.14.3 TARGET_ARCH=x86_64 sh -
export PATH=$PATH:$ROOT/istio-1.14.3/bin
sudo sh -c  "echo 'export PATH=\$PATH:$ROOT/istio-1.14.3/bin' >> /etc/profile"
source /etc/profile
istioctl install --set profile=default -y

#! Enable sidecar injection in default namespace
kubectl label namespace default istio-injection=enabled --overwrite

#! Needed in order to expose the metrics' services
INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
$ export INGRESS_DOMAIN=${INGRESS_HOST}.nip.io

#! Expose the metric services to be access via istio ingress gateway
kubectl apply -f $ROOT/configs/kiali/expose-kiali.yaml
kubectl apply -f $ROOT/configs/grafana/expose-grafana.yaml
kubectl apply -f $ROOT/configs/prometheus/expose-prometheus.yaml
kubectl apply -f $ROOT/configs/tracing/expose-tracing.yaml

#! Metrics can be accessed via:
#* Kiali: http://kiali.${INGRESS_DOMAIN}
#* Prometheus: http://prometheus.${INGRESS_DOMAIN}
#* Grafana: http://grafana.${INGRESS_DOMAIN}
#* Tracing: http://tracing.${INGRESS_DOMAIN}