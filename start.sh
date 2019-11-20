#!/bin/bash
set -e

kind create cluster --config cluster.yaml

export TILLER_NAMESPACE=tiller
kubectl apply -f ./tiller/config.yaml
helm init --service-account tiller

kubectl apply -f local-path-storage.yaml
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false", "storageclass.beta.kubernetes.io/is-default-class":"false"}}}'
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true", "storageclass.beta.kubernetes.io/is-default-class":"true"}}}'

sleep 60

reckoner plot util/course.yaml
