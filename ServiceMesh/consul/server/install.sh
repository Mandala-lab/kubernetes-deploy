#!/bin/bash

set +xeu

export CONSUL_DIR="/home/consul"
mkdit -p "$CONSUL_DIR"
cd $CONSUL_DIR || exit

# default
# https://developer.hashicorp.com/consul/tutorials/get-started-kubernetes/kubernetes-gs-deploy?variants=consul-deploy%3Aself-managed#deploy-consul-datacenter-3
#helm install \
#--values helm/values-v1.yaml \
#consul hashicorp/consul \
#--create-namespace \
#--namespace consul \
#--version "1.2.0"

# https://developer.hashicorp.com/consul/tutorials/get-started-kubernetes/kubernetes-gs-deploy?variants=consul-deploy%3Aself-managed
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install \
--values ./consul-values.yaml \
consul hashicorp/consul \
--create-namespace \
--namespace consul

set -x
