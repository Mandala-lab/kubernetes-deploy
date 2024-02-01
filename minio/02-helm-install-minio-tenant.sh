#!/bin/bash

set -x

export VERSION="5.0.11"
curl -o kubectl-minio https://github.com/minio/operator/releases/download/v${VERSION}/minio-operator_${VERSION}_linux_amd64
chmod +x kubectl-minio
mv kubectl-minio /usr/local/bin/
kubectl minio version

set +x
