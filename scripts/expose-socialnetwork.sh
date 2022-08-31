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

#! Expose the nginx-thrift, media-frontend and jaeger for the social network application:
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/socialnetwork/nginx-thrift.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/socialnetwork/media-frontend.yaml)
kubectl apply -f <(sed -e "s/INGRESS_DOMAIN/${INGRESS_DOMAIN}/" $ROOT/socialnetwork/jaeger.yaml)