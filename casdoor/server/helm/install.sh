#!/bin/bash
set -x

# https://hub.docker.com/layers/casbin/casdoor-helm-charts/
# https://casdoor.org/zh/docs/basic/try-with-helm

helm repo add casdoor oci://registry-1.docker.io/casbin/casdoor-helm-charts

#helm pull oci://registry-1.docker.io/casbin/casdoor-helm-charts --version v1.696.0
helm install casdoor oci://registry-1.docker.io/casbin/casdoor-helm-charts --version v1.696.0
#helm install casdoor \
# oci://registry-1.docker.io/casbin/casdoor-helm-charts \
#  --version 1.696.0

set +x
