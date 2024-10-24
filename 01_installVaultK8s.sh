#! /bin/bash

source ./setEnvs.sh

kubectl create ns $NAMESPACE_VAULT || true

helm repo add hashicorp https://helm.releases.hashicorp.com

# Using these settings, we are installing Vault in development mode with the UI enabled and exposed via a LoadBalancer service to access it externally. This setup is ideal for testing and development purposes.
# Running Vault in “dev” mode. This requires no further setup, no state management, and no initialization.
# This is useful for experimenting with Vault without needing to unseal, store keys, et. al.
# All data is lost on restart — do not use dev mode for anything other than experimenting.
# See https://developer.hashicorp.com/vault/docs/concepts/dev-server to know more
# See https://artifacthub.io/packages/helm/hashicorp/vault?modal=values-schema

helm upgrade -i vault hashicorp/vault \
       --set='server.dev.enabled=true' \
       --set='ui.enabled=true' \
       --set='ui.serviceType=ClusterIP' \
       --namespace $NAMESPACE_VAULT

#Install with external IP and LB
#helm update -i vault hashicorp/vault \
#       --set='server.dev.enabled=true' \
#       --set='ui.enabled=true' \
#       --set='ui.serviceType=LoadBalancer' \
#       --namespace $NAMESPACE_VAULT

kubectl rollout status deployment/vault-agent-injector --timeout 1m

kubectl get all -n $NAMESPACE_VAULT




