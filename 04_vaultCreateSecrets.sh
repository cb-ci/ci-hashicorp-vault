#! /bin/bash

source ./setEnv.sh

#kubectl config set-context --current --namespace=$NAMESPACE_VAULT
#kubectl exec -n $NAMESPACE_VAULT  vault-0 -- sh -c "vault secrets enable -mount=secrets kv"

# Create Secrets KV1
# Enable kv1 on path secrets
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault secrets enable -path=$SECRET_PATH_KV1 kv"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  put  $SECRET_PATH_KV1/cloudbees-login username=admin password=TEST123"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  list -format=json $SECRET_PATH_KV1"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  get  -format=json $SECRET_PATH_KV1/cloudbees-login"

# Create Secrets KV2
# enable kv2 on path secrets-kv2
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault secrets enable -path=$SECRET_PATH_KV2 kv-v2"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  put  $SECRET_PATH_KV2/cloudbees-login username=admin password=TEST123"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv metadata put -custom-metadata=Membership=CloudBees $SECRET_PATH_KV2/cloudbees-login"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  list -format=json $SECRET_PATH_KV2"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  get  -format=json $SECRET_PATH_KV2/cloudbees-login"

# Create Secrets for test deployment yamnl/vaultTestDeployment.yaml
# enable kv2 on path secrets
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault secrets enable -path=$SECRET_PATH_TEST kv"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  put  $SECRET_PATH_TEST/cloudbees-login username=admin password=TEST123"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  list -format=json $SECRET_PATH_TEST"
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault kv  get  -format=json $SECRET_PATH_TEST/cloudbees-login"

