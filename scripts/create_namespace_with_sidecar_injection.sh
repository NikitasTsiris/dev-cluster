#! /bin/bash

NAME=$1

kubectl create namespace $NAME
kubectl label namespace $NAME istio-injection=enabled --overwrite