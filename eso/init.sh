#! /bin/bash



NAMESPACE=external-secrets
VAULT_SERVER=http://vault.vault.svc.cluster.local:8200
VAULT_NAMESPACE=vault

# Fetch the RoleID of the AppRole:
export VAULT_ROLE_ID=$(kubectl exec -n $VAULT_NAMESPACE vault-0 -- sh -c 'vault read  -format=json auth/approle/role/jenkins-role/role-id' |  jq -cr  '.data.role_id')
# Get a SecretID issued against the AppRole:
export VAULT_SECRET=$(kubectl exec -n $VAULT_NAMESPACE vault-0 -- sh -c 'vault write -format=json -f auth/approle/role/jenkins-role/secret-id' |  jq -cr  '.data.secret_id')
echo $VAULT_ROLE_ID
echo $VAULT_SECRET



#curl \
#    --request POST \
#    --data '{"role_id":"188......","secret_id":"c839......"}' \
#    http://vault.vault.svc.cluster.local:8200/v1/auth/approle/login

# kubectl get secretstores -A 
# kubectl get events


helm repo add external-secrets https://charts.external-secrets.io
helm repo update
#
helm upgrade --install external-secrets \
   external-secrets/external-secrets \
   -n $NAMESPACE \
   --create-namespace

kubectl delete secret  vault-secret-id -n $NAMESPACE
kubectl create secret generic vault-secret-id -n $NAMESPACE \
    --from-literal=secret="$VAULT_SECRET"

#cat <<EOF | kubectl apply -n $NAMESPACE -f -
cat <<EOF > eso.yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-secret-store
  namespace: $NAMESPACE
spec:
  provider:
    vault:
      server: "${VAULT_SERVER}"
      path: "secret"
      version: "v2"
      auth:
        # VaultAppRole authenticates with Vault using the
        # App Role auth mechanism
        # https://www.vaultproject.io/docs/auth/approle
        appRole:
          # Path where the App Role authentication backend is mounted
          path: "approle"
          # RoleID configured in the App Role authentication backend
          roleId: "${VAULT_ROLE_ID}"
          # Reference to a key in a K8 Secret that contains the App Role SecretId
          secretRef:
            name: "vault-secret-id"
            key: "secret"
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: external-secret-vault-cloudbees-login
  namespace: $NAMESPACE
spec:
  refreshInterval: "10s"
  secretStoreRef:
    name: vault-secret-store
    kind: SecretStore
  target:
    name: secret-vault-cloudbess-login
  data:
    - secretKey: username
      remoteRef:
        key: cloudbees-login
        property: username
    - secretKey: password
      remoteRef:
        key: cloudbees-login
        property: password
EOF
kubectl delete -f eso.yaml
kubectl apply -f eso.yaml


