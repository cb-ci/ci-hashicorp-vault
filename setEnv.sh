#! /bin/bash

set -x
# Service account used for k8s auth for the test deployment, agent injector
export SERVICE_ACCOUNT_VAULT=vault-serviceaccount
# CloudBees CB CI service account for k8s auth (agent injector)
export SERVICE_ACCOUNT_CLOUDBEES=jenkins
# CloudBees CB CI namespace
export NAMESPACE_CLOUDBEES=cloudbees-core
# vault namespace
export NAMESPACE_VAULT=vault
# HC policy name
export VAULT_POLICY_READ=read-policy
# Secret path KV1 used for CloudBees Hashi Corp vault plugin setup and Credentials store
export SECRET_PATH_KV1=secrets-kv1
# Secret path KV2 used for CloudBees Hashi Corp vault plugin setup and Credentials store
export SECRET_PATH_KV2=secrets-kv2
# Secret path used for test deployment
export SECRET_PATH_TEST=secret

