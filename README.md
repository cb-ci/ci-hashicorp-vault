* https://medium.com/rahasak/run-hashicorp-vault-on-docker-with-filesystem-and-consul-backends-a67a7c958e02
* https://medium.com/@muppedaanvesh/a-hand-on-guide-to-vault-in-kubernetes-%EF%B8%8F-1daf73f331bd
* https://medium.com/@nanditasahu031/how-to-integrate-hashicorp-vault-with-jenkins-to-secure-your-secrets-f13bb36e28e9
* https://www.youtube.com/watch?v=05Rw1Qkjz4c
* https://developer.hashicorp.com/vault/tutorials/auth-methods/approle#step-3-get-roleid-and-secretid
* https://developer.hashicorp.com/vault/tutorials/secrets-management/versioned-kv


# Docker run

docker run: The command to run a Docker container.
* --cap-add=IPC_LOCK: Adds the IPC_LOCK capability to the container, which allows Vault to disable swap on the machine for better security (especially important in production, but often included in dev setups too).
* --name dev-vault: Names the Docker container as dev-vault.
* -e 'VAULT_DEV_ROOT_TOKEN_ID=root': Sets the Vault root token ID to root for easy access in development mode.
* -e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200': Configures Vault to listen on all interfaces on port 8200 in the container.
* -p 8200:8200: Maps port 8200 on the host machine to port 8200 in the container so you can access Vault at http://localhost:8200.
* -v ~/vault/data:/vault/file: Mounts the local directory ~/vault/data to the container's /vault/file directory. This allows Vault data to be stored persistently on the host machine, even if the container is stopped or removed.
* vault:latest: Specifies the Vault Docker image to use. You can replace latest with a specific version if needed.
* server -dev -dev-root-token-id="root" -dev-listen-address=0.0.0.0:8200: Runs Vault in development mode with the root token set to root and listening on 0.0.0.0:8200.

## Accessing Vault:
Once the container is running, you can access the Vault UI by opening your browser and navigating to http://localhost:8200.
Use the root token to log in.
## Notes:
* Development Mode: Vault in development mode is not meant for production. It stores everything in-memory and automatically initializes and unseals itself. This mode is ideal for local testing and development only.
* Data Persistence: With the volume mount (-v ~/vault/data:/vault/file), your Vault data will be saved in ~/vault/data on your host machine, allowing you to retain data across container restarts.
By following these steps, you can quickly set up a HashiCorp Vault instance in development mode using Docker with a mounted local volume.


```

./runVault.sh

You may need to set the following environment variables:

    $ export VAULT_ADDR='http://127.0.0.1:8200'

The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: R6mIPaT9VhEpeVT4ecFdF+OqysRVQtjsywkR89GWf64=
Root Token: root

Development mode should NOT be used in production installations!
```

