#! /bin/bash


source ./setEnvs.sh

#kubectl config set-context --current --namespace=$NAMESPACE_VAULT

# AppRole Authentication Method
# An “AppRole” represents a set of Vault policies and login constraints that must be met to receive a token with those policies.
# An AppRole can be created for a particular machine, or even a particular user on that machine, or a service spread across machines.

# Enable the AppRole auth method:
kubectl exec vault-0 -- sh -c "vault auth enable approle" -n $NAMESPACE_VAULT

# TODO
#kubectl exec vault-0 -- sh -c "vault secrets enable -path=secrets kv"

# Create a named role:
# token_num_uses: If the token issued by your approle needs the ability to create child tokens, you will need to set token_num_uses to 0.
# secret_id_num_uses=0: Creating unlimited secrets
# policies: Creating policy with the name of “Jenkins”
kubectl exec vault-0 -- sh -c "vault write -format=json auth/approle/role/jenkins-role token_num_uses=0 secret_id_num_uses=0 policies=$VAULT_POLICY_READ" -n $NAMESPACE_VAULT
kubectl exec vault-0 -- sh -c "vault read -format=json auth/approle/role/jenkins-role" -n $NAMESPACE_VAULT

# Fetch the RoleID of the AppRole:
export VAULT_APPROLE_ROLE_ID=$(kubectl exec vault-0 -- sh -c 'vault read  -format=json auth/approle/role/jenkins-role/role-id' -n $NAMESPACE_VAULT |  jq -cr  '.data.role_id')
# Get a SecretID issued against the AppRole:
export VAULT_APPROLE_SECRET_ID=$(kubectl exec vault-0 -- sh -c 'vault write -format=json -f auth/approle/role/jenkins-role/secret-id' -n $NAMESPACE_VAULT |  jq -cr  '.data.secret_id')

echo "#################################################"
echo "VAULT_APPROLE_ROLE_ID=$VAULT_APPROLE_ROLE_ID"
echo "VAULT_APPROLE_SECRET_ID=$VAULT_APPROLE_SECRET_ID"

echo "#################################################"
echo "CloudBees Casc jenkins.yaml:"
envsubst < yaml/casc-jenkins.yaml | tee gen-casc-jenkins.yaml