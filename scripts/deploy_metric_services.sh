#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts


#! Deploy metric tools:
# -> Prometheus
# -> Grafana
# -> Kiali
# -> Jaeger
kubectl apply -f $ROOT/istio-1.14.3/samples/addons/

#! Export the variables needed by metrics in ordered to be accessed by the
#! following yaml files:
source $SCRIPTS/ingress_env_variables.sh

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