#! /bin/bash

source ./setEnvs.sh

# Create  Policy
# We’ll create a policy that allows reading secrets. This policy will be attached to a role, which can be used to grant access to specific Kubernetes service accounts.
kubectl cp vault-config/read-policy.hcl vault-0:/home/vault/read-policy.hcl -n $NAMESPACE_VAULT
# Apply the Policy
kubectl exec vault-0 -- sh -c "vault policy write $VAULT_POLICY_READ /home/vault/read-policy.hcl" -n $NAMESPACE_VAULT