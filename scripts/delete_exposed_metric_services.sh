#! /bin/bash

kubectl -n istio-system delete gateway grafana-gateway kiali-gateway prometheus-gateway tracing-gateway
kubectl -n istio-system delete virtualservice grafana-vs kiali-vs prometheus-vs tracing-vs
kubectl -n istio-system delete destinationrule grafana kiali prometheus tracing
