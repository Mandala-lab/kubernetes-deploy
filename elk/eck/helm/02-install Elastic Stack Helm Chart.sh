#!/usr/bin/env bash
set -o errexit -o pipefail

# 先安装ECK

# 创建日志存储的目录
mkdir -p /mnt/data/160/elasticsearch/data/elasticsearch/es/master/0
mkdir -p /mnt/data/160/elasticsearch/data/elasticsearch/es/host/0
mkdir -p /mnt/data/160/elasticsearch/data/elasticsearch/es/host/1

# 授权
chmod -R 755 /mnt/data/160/elasticsearch/data/elasticsearch/es/master/0
chmod -R 755 /mnt/data/160/elasticsearch/data/elasticsearch/es/host/0
chmod -R 755 /mnt/data/160/elasticsearch/data/elasticsearch/es/host/1

## HTTP与TLS: https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-kibana-http-configuration.html
# 禁用HTTPS:
# eck-kibana:
#   enabled: true
#   spec:
#     count: 1
#     elasticsearchRef:
#       name: elasticsearch
#     http:
#       service:
#         spec:
#           type: LoadBalancer
#       tls:
#         selfSignedCertificate:
#           disabled: true

# 使用 eck-stack Helm Chart 安装 Logstash 以及 Elasticsearch、Kibana 和 Beats
# https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-stack-helm-chart.html#k8s-install-logstash-elasticsearch-kibana-helm
kubectl apply -f templates/basic-eck.yaml

# 显示初始密码. 账号是elastic
kubectl get secret elasticsearch-es-elastic-user -n elastic-system -o=jsonpath='{.data.elastic}' | base64 --decode; echo
