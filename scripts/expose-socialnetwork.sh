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

ADDED_PORTS="ports:
    - name: http
      nodePort: 30001
      port: 8080
      protocol: TCP
      targetPort: 8080
    - name: http
      nodePort: 30002
      port: 8081
      protocol: TCP
      targetPort: 8081
    - name: http
      nodePort: 30003
      port: 16686
      protocol: TCP
      targetPort: 16686"

#! Needed in order to expose the metrics' services
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

#! Configure istio ingress gateway to open the ports needed for the socialnetwork's services
kubectl get svc istio-ingressgateway -n istio-system -o yaml | \
sed -e "s/ports:/${ADDED_PORTS}/" | \
kubectl apply -f -

#! Expose the nginx-thrift, media-frontend and jaeger for the social network application:
kubectl apply -f $ROOT/socialnetwork/nginx-thrift.yaml
kubectl apply -f $ROOT/socialnetwork/media-frontend.yaml
kubectl apply -f $ROOT/socialnetwork/jaeger.yaml

echo -e "${BGreen}SocialNetwork frontend services can be accessed via: ${Color_Off}"
echo -e "${BGreen}Nginx:${Color_Off}  http://${INGRESS_HOST}:8080"
echo -e "${BGreen}Media:${Color_Off}  http://${INGRESS_HOST}:8081"
echo -e "${BGreen}Jaeger:${Color_Off} http://${INGRESS_HOST}:16686"