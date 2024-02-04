#!/bin/bash

set -x

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
cat > loki-values.yuml <<EOF
loki:
  auth_enabled: false
  commonConfig:
    replication_factor: 1
  storage:
    type: 'filesystem'
singleBinary:
  replicas: 1
EOF
helm install --values loki-values.yuml loki grafana/loki

set +x
