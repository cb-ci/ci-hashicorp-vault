#! /bin/bash

./01_installVaultK8s.sh
./02_applyPolicies.sh
./03_enable_auth_k8s.sh
./03_enable_auth_Approle.sh
./04_vaultCreateSecrets.sh
./05_k8s_testDeployment.sh
./10_openVaultUI.sh


