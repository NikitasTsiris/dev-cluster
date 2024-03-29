#! /bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset
# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && cd .. && pwd)"
SCRIPTS=$ROOT/scripts

#! Needed in order to expose the metrics' services
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')
export INGRESS_DOMAIN=${INGRESS_HOST}.nip.io

echo -e "${BGreen}ENV variables for Istio ingress:${Color_Off}"
echo -e "${BGreen}INGRESS_HOST: ${Color_Off}        ${INGRESS_HOST}"
echo -e "${BGreen}INGRESS_PORT: ${Color_Off}        ${INGRESS_PORT}"
echo -e "${BGreen}SECURE_INGRESS_PORT: ${Color_Off} ${SECURE_INGRESS_PORT}"
echo -e "${BGreen}TCP_INGRESS_PORT: ${Color_Off}    ${TCP_INGRESS_PORT}"
echo -e "${BGreen}INGRESS_DOMAIN: ${Color_Off}      ${INGRESS_DOMAIN}"

#! Deploy metric tools:
# -> Prometheus
# -> Grafana
# -> Kiali
# -> Jaeger
echo -e "${BGreen}Deploying istio addons: Kiali, Grafana, Prometheus, Jaeger Tracing...${Color_Off}"
ISTIO_VERSION=1.17.1
kubectl apply -f $ROOT/istio-$ISTIO_VERSION/samples/addons/

#! Expose the metric services to be access via istio ingress gateway
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/kiali/expose-kiali.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/grafana/expose-grafana.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/prometheus/expose-prometheus.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/configs/tracing/expose-tracing.yaml)

echo -e "${BGreen}Metric and Visualization Services can be accessed via:${Color_Off}"
echo -e "${BGreen}Kiali:${Color_Off}      http://kiali.${INGRESS_DOMAIN}"
echo -e "${BGreen}Prometheus:${Color_Off} http://prometheus.${INGRESS_DOMAIN}"
echo -e "${BGreen}Grafana:${Color_Off}    http://grafana.${INGRESS_DOMAIN}"
echo -e "${BGreen}Tracing:${Color_Off}    http://tracing.${INGRESS_DOMAIN}"
