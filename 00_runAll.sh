#! /bin/bash

echo "#####################"
./01_installVaultK8s.sh
echo "#####################"
./02_applyPolicies.sh
echo "#####################"
./03_enable_auth_k8s.sh
echo "#####################"
./03_enable_auth_Approle.sh
echo "#####################"
./04_vaultCreateSecrets.sh
echo "#####################"
./05_k8s_testDeployment.sh
echo "#####################"
./10_openVaultUI.sh
echo "#####################"


