#! /bin/bash

source ./setEnv.sh

#kubectl config set-context --current --namespace=$NAMESPACE_VAULT

# Enable kubernetes authentication
kubectl exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault auth enable kubernetes"

# Configure Kubernetes Authentication
# Configure Vault to communicate with the Kubernetes API server:
kubectl  exec -n $NAMESPACE_VAULT vault-0 -- sh -c 'vault write auth/kubernetes/config \
                               token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
                               kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
                               kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'

# Create a Role
# Create a role(vault-role) that binds the above policy to a Kubernetes service account(vault-serviceaccount) in a specific namespace.
# This allows the service account to access secrets stored in Vault:

# Bind SA SERVICE_ACCOUNT_VAULT to the read-policy in vault namespace
kubectl  exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault write auth/kubernetes/role/vault-role \
                               bound_service_account_names=$SERVICE_ACCOUNT_VAULT \
                               bound_service_account_namespaces=$NAMESPACE_VAULT \
                               policies=$VAULT_POLICY_READ \
                               ttl=1h"
# Bind SA SERVICE_ACCOUNT_CLOUDBEES to the read-policy in cloudbees-core namespace
kubectl  exec -n $NAMESPACE_VAULT vault-0 -- sh -c "vault write auth/kubernetes/role/cloudbees \
                               bound_service_account_names=$SERVICE_ACCOUNT_CLOUDBEES \
                               bound_service_account_namespaces=$NAMESPACE_CLOUDBEES \
                               policies=$VAULT_POLICY_READ \
                               ttl=1h"



# Create Service Account SERVICE_ACCOUNT_VAULT in vault namespace
# We need this for the yaml/vaultTestDeployment.yaml
kubectl apply -f yaml/vaultServiceAccount.yaml -n $NAMESPACE_VAULT