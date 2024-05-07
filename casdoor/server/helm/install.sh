#!/bin/bash
set -x

helm add casdoor casdoor/casdoor-helm-charts
helm install casdoor \
 oci://registry-1.docker.io/casbin/casdoor-helm-charts \
  --version 1.524.0


set +x
