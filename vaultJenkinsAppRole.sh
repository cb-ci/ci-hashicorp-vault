#! /bin/bash

# AppRole Authentication Method
# An “AppRole” represents a set of Vault policies and login constraints that must be met to receive a token with those policies.
# An AppRole can be created for a particular machine, or even a particular user on that machine, or a service spread across machines.

# Enable the AppRole auth method:
kubectl exec vault-0 -- sh -c "vault auth enable approle"


# Create a Policy
# We’ll create a policy that allows reading secrets. This policy will be attached to a role, which can be used to grant access to specific Kubernetes service accounts.
kubectl cp vault-config/jenkins-policy.hcl vault-0:/home/vault/jenkins-policy.hcl
# Apply the Policy
kubectl exec vault-0 -- sh -c "vault policy write jenkins /home/vault/jenkins-policy.hcl"

#kubectl exec vault-0 -- sh -c "vault secrets enable -path=secrets kv"

# Create a named role:
# token_num_uses: If the token issued by your approle needs the ability to create child tokens, you will need to set token_num_uses to 0.
# secret_id_num_uses=0: Creating unlimited secrets
# policies: Creating policy with the name of “Jenkins”
kubectl exec vault-0 -- sh -c 'vault write auth/approle/role/jenkins-role token_num_uses=0 secret_id_num_uses=0 policies="jenkins"'
# Fetch the RoleID of the AppRole:
kubectl exec vault-0 -- sh -c 'vault read auth/approle/role/jenkins-role/role-id'
# Get a SecretID issued against the AppRole:
kubectl exec vault-0 -- sh -c 'vault write -f auth/approle/role/jenkins-role/secret-id'


# Create Secrets
kubectl exec vault-0 -- sh -c "vault kv put kv1-secrets/cloudbees-login username=admin password=admin"
kubectl exec vault-0 -- sh -c "vault kv list kv1-secrets/"
kubectl exec vault-0 -- sh -c "vault kv get kv1-secrets/cloudbees-login"