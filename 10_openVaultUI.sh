#! /bin/bash

source ./setEnvs.sh

kubectl port-forward service/vault-ui   8200:8200 -n $NAMESPACE_VAULT
echo "use default login token: 'root'"
open http://localhost:8200