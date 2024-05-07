#!/usr/bin/env bash
set -o errexit -o pipefail

# https://www.cuiliangblog.cn/detail/section/127410630
# https://mp.weixin.qq.com/s/rO5dJPZ913i3Vt85J5oQ9A

k create ns jenkins

helm repo add jenkins https://charts.jenkins.io
helm repo update

helm fetch jenkins/jenkins --untar

# 修改以下配置:
# 镜像: controller.image.tag
# 镜像: controller.image.tagLabel
# 硬件资源: resources.requests.cpu
# 硬件资源: resources.requests.memory
# 硬件资源: resources.limits.cpu
# 硬件资源: resources.limits.memory
# 对外开放类型: controller.serviceType: LoadBalancer/ClusterIP/NodePort/Ingress
# 存储类storageClass: persistence.storageClass
# 数据持久化空间的存储大小: persistence.size
#

helm install jenkins -f templates/values2.yaml . -n jenkins

# 查看密码, 账号是admin
printf $(kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

# 插件推荐
# Chinese
# Gitlab
# Git Parameter
# Extended Choice Parameter
# Docker

# Kubernetes
# Pipeline

# active choices
# kubernetes Continuous Deploy
# http request
# build user vars
# description setter
# Describe With Params
# Build Name and Description Setter
# Pipeline Stage View

# 如果是拉取的SSH类型的git仓库
# 则需要在Jenkins Pod容器添加对应的主机的仓库
git ls-remote -h -- ssh://git@192.168.2.158:2222/root/full-stack-engineering.git HEAD
