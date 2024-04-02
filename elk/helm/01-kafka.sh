#!/usr/bin/env bash
set -o nounset -o errexit -o pipefail

# Kafka
helm repo add strimzi https://strimzi.io/charts/
helm install strimzi -n kafka strimzi/strimzi-kafka-operator
kubectl get pod -n kafka

# 部署kafka Kraft
# https://github.com/strimzi/strimzi-kafka-operator/tree/main/examples/kafka/kraft

# https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/kafka/kraft/kafka.yaml
wget https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/kafka/kraft/kafka.yaml

# 部署kafka Zook
# 配置文件列表: https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/kafka
# 部署具有三个 ZooKeeper 和三个 Kafka 节点的持久集群
wget https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/kafka/kafka-persistent.yaml

mkdir -pv /mnt/data/100/k8s/cluster/zookeeper
mkdir -pv /mnt/data/152/k8s/cluster/zookeeper
mkdir -pv /mnt/data/155/k8s/cluster/zookeeper

kubectl apply -f pvc/pv1.yaml
kubectl apply -f pvc/pv2.yaml
kubectl apply -f pvc/pv3.yaml

kubectl apply -f kafka-persistent.yaml -n kafka
kubectl describe -n kafka po my-cluster-zookeeper-0

cat > kafka_deploy.yaml <<EOF
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: kafka-cluster
spec:
  kafka:
    version: 3.5.1
    replicas: 3
    listeners:
      - name: plain
        port: 9092
        type: internal
        tls: false
      - name: tls
        port: 9093
        type: internal
        tls: true
    config:
      offsets.topic.replication.factor: 3
      transaction.state.log.replication.factor: 3
      transaction.state.log.min.isr: 2
      default.replication.factor: 3
      min.insync.replicas: 2
      inter.broker.protocol.version: "3.5"
    storage:
      type: jbod
      volumes:
      - id: 0
        type: persistent-claim
        size: 10Gi
        deleteClaim: false
  zookeeper:
    replicas: 3
    storage:
      type: persistent-claim
      size: 10Gi
      deleteClaim: false
  entityOperator:
    topicOperator: {}
    userOperator: {}
EOF

kubectl apply -f kafka_deploy.yaml -n kafka

# Kafka UI
## 创建configmap和ingress资源，在configmap中指定kafka连接地址。以traefik为例
cat > kafka-ui.yaml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: kafka-ui-helm-values
  namespace: kafka
data:
  KAFKA_CLUSTERS_0_NAME: "kafka-cluster"
  KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: "my-cluster-kafka-brokers.kafka.svc:9092"
  AUTH_TYPE: "DISABLED"
  MANAGEMENT_HEALTH_LDAP_ENABLED: "FALSE"
EOF
kubectl apply -f kafka-ui.yaml

## helm方式部署kafka-ui并指定配置文件
helm install kafka-ui kafka-ui/kafka-ui -n kafka --set existingConfigMap="kafka-ui-helm-values"
kubectl get po,svc -n kafka

## 对外开放
kubectl patch -n kafka service/kafka-ui -p '{"spec": {"type": "LoadBalancer"}}'

## 加入到hosts文件
echo "$(kubectl get svc kafka-ui -n kafka -o=jsonpath='{.status.loadBalancer.ingress[0].ip}') kafka.local.com" | sudo tee -a /etc/hosts

# filebeat部署配置
# rbac.yaml：创建filebeat用户和filebeat角色，并授予filebeat角色获取集群资源权限，并绑定角色与权限
cat > rbac.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: filebeat
  namespace: elk
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: filebeat
  namespace: elk
rules:
  - apiGroups: ["","apps","batch"]
    resources: ["*"]
    verbs:
      - get
      - watch
      - list
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: filebeat
  namespace: elk
subjects:
  - kind: ServiceAccount
    name: filebeat
    namespace: elk
roleRef:
  kind: ClusterRole
  name: filebeat
  apiGroup: rbac.authorization.k8s.io
EOF
