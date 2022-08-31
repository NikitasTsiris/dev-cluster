#! /bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset
# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts

#! Needed in order to expose the metrics' services
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')
export INGRESS_DOMAIN=${INGRESS_HOST}.nip.io

echo "${BGreen}ENV variables for Istio ingress:${Color_Off}"
echo "${BGreen}INGRESS_HOST: " $INGRESS_HOST
echo "${BGreen}INGRESS_PORT: " $INGRESS_PORT
echo "${BGreen}SECURE_INGRESS_PORT: " $SECURE_INGRESS_PORT
echo "${BGreen}TCP_INGRESS_PORT: " $TCP_INGRESS_PORT
echo "${BGreen}INGRESS_DOMAIN: " $INGRESS_DOMAIN

#! Deploy metric tools:
# -> Prometheus
# -> Grafana
# -> Kiali
# -> Jaeger
echo "${BGreen}Deploying istio addons: Kiali, Grafana, Prometheus, Jaeger Tracing...${Color_Off}"
kubectl apply -f $ROOT/istio-1.14.3/samples/addons/

#! Expose the metric services to be access via istio ingress gateway
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/kiali/expose-kiali.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/grafana/expose-grafana.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/prometheus/expose-prometheus.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/tracing/expose-tracing.yaml)

echo  "Metric and Visualization Services can be accessed via:${Color_Off}"
echo "${BGreen}Kiali:${Color_Off} http://kiali.${INGRESS_DOMAIN}"
echo "${BGreen}Prometheus:${Color_Off} http://prometheus.${INGRESS_DOMAIN}"
echo  "Grafana:${Color_Off} http://grafana.${INGRESS_DOMAIN}"
echo "${BGreen}Tracing:${Color_Off} http://tracing.${INGRESS_DOMAIN}"
