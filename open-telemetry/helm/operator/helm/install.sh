#!/bin/bash

set -x

# 要在现有集群中安装 Operator，请确保已安装 cert-manager 并运行
# 安装 cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml

helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm install my-opentelemetry-operator open-telemetry/opentelemetry-operator \
  --set admissionWebhooks.certManager.enabled=false \
  --set admissionWebhooks.certManager.autoGenerateCert.enabled=true \
  --create-namespace \
  --values values.yaml \
  -n opentelemetry-operator

kubectl get po,svc -n opentelemetry-operator -owide

kubectl apply -f - <<EOF
apiVersion: opentelemetry.io/v1alpha1
kind: OpenTelemetryCollector
metadata:
  name: simplest
spec:
#  image: ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-contrib:0.90.1
  config: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 192.168.2.100:31461
          http:
            endpoint: 192.168.2.100:30188
    processors:
      #resource:
        #attributes:
          #- action: insert
            #key: loki.resource.labels
            #value: service.name, k8s.container.name, k8s.namespace.name, k8s.pod.name

    exporters:
      debug:
        #verbosity: detailed
      #loki:
        #endpoint: "http://loki.default.svc.cluster.local:3100/loki/api/v1/push"
        #tls:
          #insecure: true
        #default_labels_enabled:
          #exporter: true
          #job: true

    service:
      pipelines:
        logs:
          receivers: [otlp]
          #processors: [resource]
          processors: []
          #exporters: [loki]
          exporters: []
EOF

watch kubectl get opentelemetrycollector.opentelemetry.io

set +x
