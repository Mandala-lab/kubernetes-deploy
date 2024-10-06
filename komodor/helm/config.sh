#!/usr/bin/env bash
# 启用 POSIX 模式并设置严格的错误处理机制
set -o posix errexit -o pipefail

helm repo add komodorio https://helm-charts.komodor.io
helm repo update
helm install komodor-agent komodorio/komodor-agent \
--set apiKey=d622647b-d58d-4ca7-bbcb-519fb5280623 \
--set clusterName=mandala \
--timeout=90s

open https://app.komodor.com/main/services
