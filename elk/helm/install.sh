#!/bin/bash
set -o nounset -o errexit -o pipefail

mkdir -pv /home/kubernetes/elasticsearch
cd /home/kubernetes/elasticsearch || exit

helm repo add elastic https://helm.elastic.co

helm pull elastic/elasticsearch
helm pull elastic/logstash
helm pull elastic/kibana

tar -xzvf elasticsearch-*.tgz
tar -xzvf logstash-*.tgz
tar -xzvf kibana-*.tgz

helm install elasticsearch ./elasticsearch -n elk
helm install logstash ./logstash -n elk
helm install kibana ./kibana -n elk

kubectl get pods --namespace=elk -l release=kibana -w
kubectl get secrets --namespace=elk elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d
# PGi4x7QjTHhaEGrx
kubectl get secrets --namespace=elk kibana-kibana-es-token -ojsonpath='{.data.token}' | base64 -d
# AAEAAWVsYXN0aWMva2liYW5hL2tpYmFuYS1raWJhbmE6dUl4WUVIUnFRVDJiZ2tGbHB2eUQ2Zw

