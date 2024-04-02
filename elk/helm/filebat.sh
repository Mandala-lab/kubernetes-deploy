#!/usr/bin/env bash
set -o errexit -o pipefail

mkdir -p /home/kubernetes/elasticsearch/
mkdir -p /home/kubernetes/elasticsearch/filebeat
cd /home/kubernetes/elasticsearch/filebeat

# filebeat部署配置
# curl -L -O https://raw.githubusercontent.com/elastic/beats/8.13/deploy/kubernetes/filebeat-kubernetes.yaml

kubectl create ns elk

# rbac.yaml：创建filebeat用户和filebeat角色，并授予filebeat角色获取集群资源权限，并绑定角色与权限。
kubectl apply -f ./templates/rbac.yaml

# 使用filebeat.autodiscover方式自动获取pod日志，避免新增pod时日志采集不到的情况发生，并将日志发送到kafka消息队列中
# 把./templates/filebeat-conf.yaml文件修改为对应的monitoring配置
kubectl apply -f ./templates/filebeat-conf.yaml

# filebeat.yaml：使用daemonset方式每个节点运行一个filebeat容器，并挂载filebeat配置文件、数据目录、宿主机日志目录
kubectl apply -f ./templates/filebeat.yaml

# 查看pod信息，在集群每个节点上运行了一个filebeat采集容器
kubectl get pod -n elk | grep filebeat
