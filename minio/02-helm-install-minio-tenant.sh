#!/bin/bash

set -x

export VERSION="5.0.11"
curl -o kubectl-minio https://github.com/minio/operator/releases/download/v${VERSION}/minio-operator_${VERSION}_linux_amd64
chmod +x kubectl-minio
mv kubectl-minio /usr/local/bin/

export NAMESPACE="minio-users"
export TENANT_NAME="user"
export CAPACITY="10Gi"
export SERVERS="1"
export VOLUMES="1"
kubectl create ns "$NAMESPACE"
kubectl minio tenant create $TENANT_NAME \
--capacity $CAPACITY \
--servers $SERVERS \
--volumes $VOLUMES \
--namespace "$NAMESPACE"

kubectl minio version

export TENANT_NAME="user"
export NAMESPACE="minio-users"
export NFS_PATH="/mnt/data"
export NFS_SERVER="192.168.2.160"
#cat > minio-$TENANT_NAME-pv.yaml <<EOF
#apiVersion: v1
#kind: PersistentVolume
#metadata:
#  name: $TENANT_NAME  # 用你想要的PV名称替换your-pv-name
#spec:
#  capacity:
#    storage: $CAPACITY  # 用PVC中定义的存储大小替换5Gi
#  volumeMode: Filesystem
#  accessModes:
#    - ReadWriteOnce
#  persistentVolumeReclaimPolicy: Retain  # 根据你的需求选择保留策略
#  storageClassName: nfs-csi  # 用PVC中定义的存储类替换nfs-csi
#  mountOptions:
#    - vers=4.1  # 根据你的NFS服务器配置添加挂载选项
#  nfs:
#    path: $NFS_PATH  # 用你的NFS路径替换/your-nfs-path
#    server: $NFS_SERVER # 用你的NFS服务器地址替换your-nfs-server
#EOF
export TENANT_NAME="user"
cat > minio-$TENANT_NAME-pv.yaml <<EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: $TENANT_NAME
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: nfs-csi
  resources:
    requests:
      storage: 20Gi
EOF
kubectl apply -f minio-$TENANT_NAME-pv.yaml

 Username: YeNGc1UywoHdao4y
  Password: F0ckFLQpwJ7q0mCOhtXY9gqYdkfHZobV
  Note: Copy the credentials to a secure location. MinIO will not display these again

set +x
