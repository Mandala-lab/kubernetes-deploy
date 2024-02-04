#!/bin/bash

set -x

helm repo add minio-operator https://operator.min.io
helm install \
  --namespace minio-operator \
  --create-namespace \
  operator minio-operator/operator

pods=$(kubectl get pods -n minio-operator -o=jsonpath='{.items[*].metadata.name}')

# 检查每个pod的状态，直到所有的pod都处于Running状态
for pod in $pods
do
    status=$(kubectl get pod $pod -n minio-operator -o=jsonpath='{.status.phase}')
    while [ "$status" != "Running" ]
    do
        echo "Pod $pod is not running yet, waiting..."
        sleep 5
        status=$(kubectl get pod $pod -n minio-operator -o=jsonpath='{.status.phase}')
    done
    echo "Pod $pod is running"
done
echo "All pods in minio-operator namespace are running"

kubectl patch service console -n minio-operator --type='json' -p='[{"op": "replace", "path": "/spec/type", "value": "LoadBalancer"}]'

# installed jq
# kubectl get secret/console-sa-secret -n minio-operator -o json | jq -r ".data.token" | base64 -d
kubectl get secret/console-sa-secret -n minio-operator -o jsonpath="{.data.token}" | base64 -d
set +x
