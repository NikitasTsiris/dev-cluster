#! /bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset
# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green

echo -e "${BGreen}Deleting gateways...${Color_Off}"
kubectl -n istio-system delete gateway grafana-gateway kiali-gateway prometheus-gateway tracing-gateway
echo -e "${BGreen}Deleting virtual services...${Color_Off}"
kubectl -n istio-system delete virtualservice grafana-vs kiali-vs prometheus-vs tracing-vs
echo -e "${BGreen}Deleting destination rules...${Color_Off}"
kubectl -n istio-system delete destinationrule grafana kiali prometheus tracing
