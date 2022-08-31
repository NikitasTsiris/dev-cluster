#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts

#! Needed in order to expose the metrics' services
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')
export INGRESS_DOMAIN=${INGRESS_HOST}.nip.io

#! Deploy metric tools:
# -> Prometheus
# -> Grafana
# -> Kiali
# -> Jaeger
kubectl apply -f $ROOT/istio-1.14.3/samples/addons/

#! Expose the metric services to be access via istio ingress gateway
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/kiali/expose-kiali.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/grafana/expose-grafana.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/prometheus/expose-prometheus.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/tracing/expose-tracing.yaml)

#! Metrics can be accessed via:
#* Kiali: http://kiali.${INGRESS_DOMAIN}
#* Prometheus: http://prometheus.${INGRESS_DOMAIN}
#* Grafana: http://grafana.${INGRESS_DOMAIN}
#* Tracing: http://tracing.${INGRESS_DOMAIN}
