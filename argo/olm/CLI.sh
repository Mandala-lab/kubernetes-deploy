#!/usr/bin/env bash
# 启用 POSIX 模式并设置严格的错误处理机制
set -o posix errexit -o pipefail

# https://github.com/argoproj-labs/argocd-operator/releases/tag
VERSION="v0.9.1"
wget https://github.com/argoproj-labs/argocd-operator/archive/refs/tags/${VERSION}.zip

# 安装操作员, 此 Operator 将安装在 “operators” 命名空间中，并可从集群中的所有命名空间中使用
kubectl create -f https://operatorhub.io/install/argocd-operator.yaml
kubectl get csv -n operators

# 安装argocd实例
kubectl create ns argocd
kubectl create -f argocd-deploy.yaml -n argocd
# 如果需要再argocd-cm添加任何参数, 请编辑argocd.deploy.yaml的spec.extraConfig, 例如
# spec:
#   extraConfig:
#     accounts.admin: "apiKey, login"

# 获取密码
pwd=$(kubectl -n argocd get secret example-argocd-cluster -o jsonpath='{.data.admin\.password}' | base64 -d)
# tVEO1vRShlfkWysUCuKTw432oXzmB7ZN

# CLI登录
# 可选:
# --insecure: 忽略TLS验证
# --grpc-web
lb_ip=$(kubectl get service example-argocd-server -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n argocd)
argocd login \
$lb_ip \
--username admin \
--password $pwd \
--insecure

# 修改密码
argocd account update-password

# 列出当前集群上下文
kubectl config get-contexts -o name

# 添加集群权限级别的RBAC,即可在任意ns创建/删除应用(需要注意安全性), 示例:
argocd cluster add kubernetes-admin@kubernetes

# 创建APP
argocd app create guestbook \
--repo https://github.com/argoproj/argocd-example-apps.git \
--path guestbook \
--dest-server https://kubernetes.default.svc \
--dest-namespace default

# 删除
argocd app delete guestbook

# 列出用户
argocd account list

# 获取特定用户信息
argocd account get --account <username>

# 生成token
argocd account generate-token --account admin
# token:
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhcmdvY2QiLCJzdWIiOiJhZG1pbjphcGlLZXkiLCJuYmYiOjE3MTQ5Mjg0MTYsImlhdCI6MTcxNDkyODQxNiwianRpIjoiYzJiNTAzYzAtNmI0Mi00MzljLTliYTQtNjk1M2E5ZjU5OGZiIn0.t1AjKKWYNBshV5oGFYXOQCfWX-S_u2hX3NcHS3WPMrM

# RBAC权限:
# p, role:admin, applications, *, */*, allow
# p, role:admin, clusters, get, *, allow
# p, role:admin, repositories, get, *, allow
# p, role:admin, repositories, create, *, allow
# p, role:admin, repositories, update, *, allow
# p, role:admin, repositories, delete, *, allow
# p, role:admin, projects, get, *, allow
# p, role:admin, projects, create, *, allow
# p, role:admin, projects, update, *, allow
# p, role:admin, projects, delete, *, allow
# p, role:admin, logs, get, *, allow
# p, role:admin, exec, create, */*, allow
# g, admin, role:admin

# 验证RBAC权限:
# 验证包含rbac的yml或csv文件
argocd admin settings rbac validate --policy-file argocd-rbac-cm.yml
# 命名空间:
argocd admin settings rbac validate --namespace argocd

# 测试策略
# https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/#testing-a-policy
argocd admin settings rbac can role:org-admin get applications --policy-file argocd-rbac-cm.yaml

