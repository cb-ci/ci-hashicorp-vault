#! /bin/bash

NS_VAULT=vault
kubectl create ns $NS_VAULT || true

helm repo add hashicorp https://helm.releases.hashicorp.com

# Using these settings, we are installing Vault in development mode with the UI enabled and exposed via a LoadBalancer service to access it externally. This setup is ideal for testing and development purposes.
# Running Vault in “dev” mode. This requires no further setup, no state management, and no initialization.
# This is useful for experimenting with Vault without needing to unseal, store keys, et. al.
# All data is lost on restart — do not use dev mode for anything other than experimenting.
# See https://developer.hashicorp.com/vault/docs/concepts/dev-server to know more
helm install vault hashicorp/vault \
       --set='server.dev.enabled=true' \
       --set='ui.enabled=true' \
       --set='ui.serviceType=LoadBalancer' \
       --namespace $NS_VAULT

kubectl get all -n $NS_VAULT

# Create a Policy
# We’ll create a policy that allows reading secrets. This policy will be attached to a role, which can be used to grant access to specific Kubernetes service accounts.
kubectl cp vault-config/read-policy.hcl vault-0:/home/vault/read-policy.hcl

# Apply the Policy
kubectl exec vault-0 -- sh -c "vault policy write read-policy /home/vault/read-policy.hcl"

# Enable kubernetes authentication
kubectl exec vault-0 -- sh -c "vault auth enable kubernetes"

# Configure Kubernetes Authentication
# Configure Vault to communicate with the Kubernetes API server:

kubectl exec vault-0 -- sh -c 'vault write auth/kubernetes/config \
                               token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
                               kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
                               kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'

# Create a Role
# Create a role(vault-role) that binds the above policy to a Kubernetes service account(vault-serviceaccount) in a specific namespace.
# This allows the service account to access secrets stored in Vault:

kubectl exec vault-0 -- sh -c "vault write auth/kubernetes/role/vault-role \
                                bound_service_account_names=vault-serviceaccount \
                                bound_service_account_namespaces=vault \
                                policies=read-policy \
                                ttl=1h"

kubectl exec vault-0 -- sh -c "vault write auth/kubernetes/role/cloudbees \
                               bound_service_account_names=jenkins \
                               bound_service_account_namespaces=cloudbees-core \
                               policies=read-policy \
                               ttl=1h"

# Create Secrets

#kubectl exec vault-0 -- sh -c "vault kv put secret/login pattoken=shdfsdfgjrtvrovfhsdvef"

kubectl exec vault-0 -- sh -c "vault kv put secret/cloudbees-login username=admin password=admin"

kubectl exec vault-0 -- sh -c "vault kv list secret/cloudbees-login"

kubectl exec vault-0 -- sh -c "vault kv get  secret/cloudbees-login"


#  Create Test Deployment


cat << EOF | kubectl apply -f -
 apiVersion: v1
 kind: ServiceAccount
 metadata:
   name: vault-serviceaccount
   labels:
     app: read-vault-secret

EOF