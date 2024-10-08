#!/bin/bash
# https://min.io/docs/minio/kubernetes/upstream/operations/install-deploy-manage/delete-minio-tenant.html#

export TENANT_NAME="user"
export TENANT_NAMESPACE="user"

kubectl minio tenant delete $TENANT_NAME \
              --namespace $TENANT_NAMESPACE
