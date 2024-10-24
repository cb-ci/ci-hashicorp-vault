#! /bin/bash

source ./setEnv.sh

#kubectl config set-context --current --namespace=$NAMESPACE_VAULT

# Create Secrets
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  put  secret/cloudbees-login username=admin password=admin"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  list secret/cloudbees-login"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  get  secret/cloudbees-login"


# Create Secrets
#kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  put  kv1-secrets/cloudbees-login username=admin password=admin"
#kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  list kv1-secrets/cloudbees-login"
#kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  get  kv1-secrets/cloudbees-login"