#! /bin/bash

source ./setEnvs.sh

#kubectl config set-context --current --namespace=$NAMESPACE_VAULT

# Create Secrets
kubectl exec vault-0 -- sh -c "vault kv  put  secret/cloudbees-login username=admin password=admin" -n $NAMESPACE_VAULT
kubectl exec vault-0 -- sh -c "vault kv  list secret/cloudbees-login" -n $NAMESPACE_VAULT
kubectl exec vault-0 -- sh -c "vault kv  get  secret/cloudbees-login" -n $NAMESPACE_VAULT


# Create Secrets
#kubectl exec vault-0 -- sh -c "vault kv  put  kv1-secrets/cloudbees-login username=admin password=admin" -n $NAMESPACE_VAULT
#kubectl exec vault-0 -- sh -c "vault kv  list kv1-secrets/cloudbees-login" -n $NAMESPACE_VAULT
#kubectl exec vault-0 -- sh -c "vault kv  get  kv1-secrets/cloudbees-login" -n $NAMESPACE_VAULT