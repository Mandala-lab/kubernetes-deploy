#!/usr/bin/env bash
# 启用 POSIX 模式并设置严格的错误处理机制
set -o posix errexit -o pipefail

https://blog.csdn.net/lwlfox/article/details/104880227

wget https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# 自动补全
cat >> ~/.bashrc <<EOF
source <(helm completion bash)
EOF

