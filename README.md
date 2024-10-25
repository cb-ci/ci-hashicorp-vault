# CloudBees CI Hashicorp vault example

The scripts in this repository  are about to:
* Install Hashi corp vault in a K8s cluster
* Enable Approle and Kubernetes authentication in Hashi Corp Vault
* Create secrets in vault using KV1 and KV2
* Install a k8s test deployment to demo the Hashi Corp Agent injector
* Create a CloudBees CasC sniplet you can use to provision a test Controller from
* Contains a Jenkins test Pipeline and a credentials decrypt script 

# Pre-requirements

* Kubernetes cluster with cluster admin sa
* Tools: kubectl, jq
* CloudBees Ci CasC Controller

# Scripts

| Script                                                   | Note                                                                                                               |
|----------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| [00_runAll.sh](./00_runAll.sh)                           | Executes all scripts, except the `11_uninstallVault.sh`                                                            |
| [01_installVaultK8s.sh](./01_installVaultK8s.sh)         | Install Hashi Corp vault in developer mode in a new vault namespace                                                |
| [02_applyPolicies.sh](./02_applyPolicies.sh)             | Apply the read policies                                                                                            |
| [03_enable_auth_Approle.sh](./03_enable_auth_Approle.sh) | Enable `Approle` auth for CloudBees CI                                                                               |
| [03_enable_auth_k8s.sh](./03_enable_auth_k8s.sh)         | Enable `K8s` auth for the test Deployment.                                                                           |
| [04_vaultCreateSecrets.sh](./04_vaultCreateSecrets.sh)   | Creates some test secrets we will read lateron in CloudBees credentials provider as well as in the test deployment |
| [05_k8s_testDeployment.sh](./05_k8s_testDeployment.sh)   | Deploys a k8s deployment that has the Hashi Corps agent injector configured                                        |
| [10_openVaultUI.sh](./10_openVaultUI.sh)                 | Creates k8s port forwarding to the vault UI                                                                        |
| [11_uninstallVault.sh](./11_uninstallVault.sh)           | Uninstall vault and delete the namespace                                                                           |

# Start 

* Execute the [00_runAll.sh](./00_runAll.sh) script
* Optional: open http://localhost:8200 in your Browser to access the vault UI (default token is root)

# Delete 

* Execute [11_uninstallVault.sh](./11_uninstallVault.sh) to delete vault and the vault namespace 

# Test 

* AgentInjector: Execute the [05_k8s_testDeployment.sh](./05_k8s_testDeployment.sh) script and see the output. You should see the decrypted credentials read from vault 
* CasC credentials store: 
  * Create a test controller using the CasC sniplet that wil be generated, see also the template in `yaml/casc-jenkins.yaml`
  * Create a test Pipeline using this Jenkinsfile: `[Jenkinsfile.groovy](test/Jenkinsfile.groovy)`
  * Decrypt credentials in your Controller using this script in script console: `test/decryptCredentials.groovy`

# Links 

* https://docs.cloudbees.com/docs/cloudbees-ci/latest/cloud-secure-guide/hashicorp-vault-plugin
* https://medium.com/rahasak/run-hashicorp-vault-on-docker-with-filesystem-and-consul-backends-a67a7c958e02
* https://medium.com/@muppedaanvesh/a-hand-on-guide-to-vault-in-kubernetes-%EF%B8%8F-1daf73f331bd
* https://medium.com/@nanditasahu031/how-to-integrate-hashicorp-vault-with-jenkins-to-secure-your-secrets-f13bb36e28e9
* https://www.youtube.com/watch?v=05Rw1Qkjz4c
* https://developer.hashicorp.com/vault/tutorials/auth-methods/approle#step-3-get-roleid-and-secretid
* https://developer.hashicorp.com/vault/tutorials/secrets-management/versioned-kv














