#! /bin/bash
# Used vor vault CLI
export VAULT_ADDR='http://0.0.0.0:8200'

docker pull hashicorp/vault:latest


mkdir -p $(pwd)/vault/data
docker run --cap-add=IPC_LOCK \
   --name dev-vault \
   -e 'VAULT_DEV_ROOT_TOKEN_ID=root' \
   -e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200' \
   -e 'VAULT_ADDR=http://0.0.0.0:8200' \
   -p 8200:8200 \
   -v $(pwd)/vault/data:/vault/file \
   hashicorp/vault:latest server -dev -dev-root-token-id="root" -dev-listen-address=0.0.0.0:8200


