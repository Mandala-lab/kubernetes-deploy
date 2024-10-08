#!/usr/bin/env bash
# 启用 POSIX 模式并设置严格的错误处理机制
set -o posix errexit -o pipefail

# 安装operator
wget https://github.com/jaegertracing/jaeger-operator/releases/download/v1.60.0/jaeger-operator.yaml

# 通过operator crd创建jaeger实例
cat > jaeger.yml <<EOF
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: simple-prod
spec:
  strategy: production
  collector:
    maxReplicas: 1
    resources:
      limits:
        cpu: 100m
        memory: 128Mi
EOF

kubectl apply -f jaeger.yml -n observability

# 启用UI的NodePort类型的转发
kubectl patch svc simple-prod-query -n observability -p '{"spec":{"type":"NodePort"}}'
