#!/usr/bin/env bash
# 启用 POSIX 模式并设置严格的错误处理机制
set -o posix errexit -o pipefail

helm repo add higress.io https://higress.io/helm-charts
helm install higress -n higress . --create-namespace

# helm install higress . -n higress --create-namespace

# helm uninstall higress -n higress


#cat > higress-console.yaml <<EOF
#apiVersion: networking.k8s.io/v1
#kind: Ingress
#metadata:
#  name: higress-console
#  namespace: higress
#spec:
#  ingressClassName: higress
#  rules:
#    - host: higress.k8s.local
#      http:
#        paths:
#          - path: /
#            pathType: Prefix
#            backend:
#              service:
#                name: higress-console
#                port:
#                  number: 8080
#EOF
#kubectl apply -f higress-console.yaml

helm install higress -n higress . --create-namespace
k get svc -n higress
