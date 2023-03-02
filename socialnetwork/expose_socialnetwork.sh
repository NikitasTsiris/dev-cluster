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

#!
#!
#TODO: Need to configure istio ingress gateway to open the ports needed for the socialnetwork's services
#!
#!

$SCRIPTS/create_namespace_with_sidecar_injection.sh social-network

#! Expose the nginx-thrift, media-frontend and jaeger for the social network application:
kubectl apply -f $ROOT/socialnetwork/nginx-thrift.yaml
kubectl apply -f $ROOT/socialnetwork/media-frontend.yaml
kubectl apply -f $ROOT/socialnetwork/jaeger.yaml

echo -e "${BGreen}SocialNetwork frontend services can be accessed via: ${Color_Off}"
echo -e "${BGreen}Nginx:${Color_Off}  http://${INGRESS_HOST}:8080"
echo -e "${BGreen}Media:${Color_Off}  http://${INGRESS_HOST}:8081"
echo -e "${BGreen}Jaeger:${Color_Off} http://${INGRESS_HOST}:16686"