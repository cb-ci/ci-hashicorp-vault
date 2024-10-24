#! /bin/bash

source ./setEnvs.sh

# delete vault
helm uninstall vault --namespace $NAMESPACE_VAULT
# delete test deployment
kubectl delete -f yaml/vaultTestDeployment.yaml
#deete test service account
kubectl delete -f yaml/vaultServiceAccount.yaml
#delete namespace
kubectl delete ns $NAMESPACE_VAULT