#! /bin/bash

source ./setEnv.sh

#kubectl config set-context --current --namespace=$NAMESPACE_VAULT

#  Create Test Deployment in vault namespace
# This deployment manifest creates a single replica of an Nginx pod configured to securely fetch secrets from Vault.
# The Vault Agent injects the secrets cloudbees-login into the pod according to the specified templates.
# The secrets are stored in the pod's filesystem and can be accessed by the application running in the container.
# The SERVICE_ACCOUNT_VAULT service account, which has the necessary permissions, is used to authenticate with Vault.
#envsubst < yaml/vaultTestDeployment.yaml | tee gen-vaultTestDeployment.yaml
kubectl apply -f yaml/vaultTestDeployment.yaml -n $NAMESPACE_VAULT

kubectl rollout status deployment.apps/vault-test --timeout 1m


# Read secret
kubectl exec -n $NAMESPACE_VAULT deployment.apps/vault-test  -- sh -c "cat /vault/secrets/cloudbees-login"