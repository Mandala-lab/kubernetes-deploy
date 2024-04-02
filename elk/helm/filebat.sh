#!/usr/bin/env bash
set -o errexit -o pipefail

mkdir -p /home/kubernetes/elasticsearch/
mkdir -p /home/kubernetes/elasticsearch/filebeat
cd /home/kubernetes/elasticsearch/filebeat

# filebeat部署配置
# curl -L -O https://raw.githubusercontent.com/elastic/beats/8.13/deploy/kubernetes/filebeat-kubernetes.yaml

kubectl create ns elk

crictl pull elastic/filebeat:8.13.1
crictl pull elastic/logstash:8.13.1

# rbac.yaml：创建filebeat用户和filebeat角色，并授予filebeat角色获取集群资源权限，并绑定角色与权限。
kubectl apply -f ./templates/rbac.yaml

# 使用filebeat.autodiscover方式自动获取pod日志，避免新增pod时日志采集不到的情况发生，并将日志发送到kafka消息队列中
# 把./templates/filebeat-conf.yaml文件修改为对应的monitoring配置
kubectl apply -f ./templates/filebeat-conf.yaml

# filebeat.yaml：使用daemonset方式每个节点运行一个filebeat容器，并挂载filebeat配置文件、数据目录、宿主机日志目录
kubectl apply -f ./templates/filebeat.yaml

# logstash-log4j2.yaml：容器方式运行时，logstash日志默认使用的console输出, 不记录到日志文件中, logs目录下面只有gc.log，我们可以通过配置log4j2设置，将日志写入到文件中，方便fleet采集分析logstash日志。
kubectl apply -f ./templates/logstash-log4j2.yaml

# logstash-conf.yaml：修改Logstash配置，禁用默认的指标收集配置，并指定es集群uuid
kubectl apply -f ./templates/logstash-conf.yaml

# pod-pipeline.yaml：配置pipeline处理pod日志规则，从kafka读取数据后移除非必要的字段，然后写入ES集群中
kubectl apply -f ./templates/pod-pipeline.yaml

# pod-logstash.yaml：部署2副本的logstash容器，挂载pipeline、log4j2、logstash配置文件、日志路径资源。
kubectl apply -f ./templates/pod-logstash.yaml

# logstash-svc.yaml：创建svc资源，用于暴露logstash监控信息接口。
kubectl apply -f ./templates/logstash-svc.yaml


# 查看pod信息，在集群每个节点上运行了一个filebeat采集容器
kubectl get pod -n elk | grep filebeat
