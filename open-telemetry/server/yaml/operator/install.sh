#!/bin/bash

set -x

kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml

kubectl apply -f - <<EOF
apiVersion: opentelemetry.io/v1alpha1
kind: OpenTelemetryCollector
metadata:
  name: otel-collector
spec:
  config: |
    receivers:
      otlp:
        protocols:
          grpc:
          http:
      #prometheus:
      #  config:
      #    scrape_configs:
      #    - job_name: 'otel-collector'
      #      scrape_interval: 10s
      #      static_configs:
      #      - targets: [ '0.0.0.0:8888' ]
      #      metric_relabel_configs:
      #      - action: labeldrop
      #        regex: (id|name)
      #      - action: labelmap
      #        regex: label_(.+)
      #        replacement: $$1

    processors:
      batch:

    exporters:
      otlp:
        endpoint: "jaeger-collector.istio-system.svc.cluster.local:4317"
        tls:
          insecure: true
      prometheus:
        endpoint: "0.0.0.0:8889" # Expose an endpoint for Prometheus to scrape
        #metric_expiration: 10m
        namespace: "default"
        const_labels:
          label1: "value1"
      #prometheusremotewrite:
        #endpoint: http://prometheus.observability-backend.svc.cluster.local:80/api/v1/write
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch]
          exporters: [otlp]
        metrics:
          receivers: [otlp]
          processors: [batch]
          exporters: [prometheus]
EOF
k get opentelemetrycollector.opentelemetry.io
kubectl get po,deploy,service -l app.kubernetes.io/component=opentelemetry-collector
set +x
