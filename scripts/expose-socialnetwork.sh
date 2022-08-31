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

#! Expose the nginx-thrift, media-frontend and jaeger for the social network application:
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/socialnetwork/nginx-thrift.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/socialnetwork/media-frontend.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/socialnetwork/jaeger.yaml)

echo -e "${BGreen}SocialNetwork frontend services can be accessed via: ${Color_Off}"
echo -e "${BGreen}Nginx:${Color_Off} http://nginx.${INGRESS_DOMAIN}"
echo -e "${BGreen}Media:${Color_Off} http://media.${INGRESS_DOMAIN}"
echo -e "${BGreen}Jaeger:${Color_Off} http://jaeger.${INGRESS_DOMAIN}"