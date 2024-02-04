#!/bin/bash

set -x
# 要在现有集群中安装 Operator，请确保已安装 cert-manager 并运行
# 不建议在生产环境使用

# 安装 cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml

kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml

set +x
