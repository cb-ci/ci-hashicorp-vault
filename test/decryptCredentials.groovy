def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
        com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
        Jenkins.instance,
        null,
        null
)

creds.each { println("Credentials class: " + it.id + it.class) }

println()

for(c in creds) {
    if(c instanceof com.cloudbees.jenkins.plugins.vault.credentials.VaultSshPrivateKeyCredentials){
        println(String.format("id=%s desc=%s user=%s key=%s", c.id, c.description, c.username, c.privateKey))
    }
    if (c instanceof com.cloudbees.jenkins.plugins.vault.credentials.VaultUsernamePasswordCredentials){
        println(String.format("id=%s  desc=%s user=%s pass=%s", c.id, c.description,c.username, c.password))
    }
}