#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts

#! Needed in order to expose the metrics' services
INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
#INGRESS_DOMAIN=${INGRESS_HOST}.nip.io
sudo sh -c  "echo 'export INGRESS_DOMAIN=${INGRESS_HOST}.nip.io' >> /etc/profile"
source /etc/profile

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