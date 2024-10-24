#! /bin/bash

set -x
export SERVICE_ACCOUNT_VAULT=vault-serviceaccount
export SERVICE_ACCOUNT_CLOUDBEES=jenkins
export NAMESPACE_CLOUDBEES=cloudbees-core
export NAMESPACE_VAULT=vault
export VAULT_POLICY_READ=read-policy
export SECRET_PATH_KV1=secrets-kv1
export SECRET_PATH_KV2=secrets-kv2
#Used for test deployment
export SECRET_PATH_TEST=secret

