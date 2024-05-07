#!/usr/bin/env bash
# 启用 POSIX 模式并设置严格的错误处理机制
set -o posix errexit -o pipefail

curl -s https://fluxcd.io/install.sh | sudo bash
cat >> ~/.bashrc <<EOF
. <(flux completion bash)
EOF
source  ~/.bashrc


flux check --pre

# https://fluxcd.io/flux/installation/bootstrap/gitlab/
# https://fluxcd.io/flux/installation/bootstrap/github/

# https://fluxcd.io/flux/installation/bootstrap/gitlab/#gitlab-personal-account
# 登录到您的GitLab账户。
#
#在右上角的用户菜单中，选择“Settings”（设置）。
#
#在左侧导航栏中，选择“Access Tokens”（访问令牌）。
#
#如果您是第一次创建访问令牌，系统可能会要求您验证身份或提供额外信息。
#
#点击“Create personal access token”（创建个人访问令牌）按钮。
#
#输入访问令牌的名称，以及选择此访问令牌的过期日期（可选）。
#
#选择此访问令牌的权限范围，例如读取用户信息、访问存储库、管理存储库等。

export GITLAB_TOKEN="glpat-rEu2tTe2gX-7qRio2wyu"
# --hostname: 主机/域名, 必须是HTTPS
# --token-auth: 从变量GITLAB_TOKEN读取
# --branch: 分支
# --private=<bool> 如果指定的项目不存在，Flux 会将其创建为私有项目。如果要创建公共项目，请设置 --private=false .
#--path=. 配置 Flux 组件以跟踪存储库中的路径

# 引导脚本执行以下操作：
#
# Creates a deploy token and saves it as a Kubernetes secret.
# 创建部署令牌并将其另存为 Kubernetes secret 。
# Creates an empty GitLab project, if the project specified by the --repository argument doesn’t exist.
# 如果 --repository 参数指定的项目不存在，则创建一个空的 GitLab 项目。
# Generates Flux definition files for your project in a folder specified by the --path argument.
# 在 --path 参数指定的文件夹中为项目生成 Flux 定义文件。
# Commits the definition files to the branch specified by the --branch argument.
# 将定义文件提交到 --branch 参数指定的分支。
# Applies the definition files to your cluster.
# 将定义文件应用于集群。
flux bootstrap gitlab \
  --token-auth \
  --owner=lookeke \
  --repository=full-stack-engineering2 \
  --branch=main \
  --path=./clusters/my-cluster \
  --private=false \
  --personal
