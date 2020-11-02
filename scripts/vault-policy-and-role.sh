#!/bin/bash

# export NS 
export NS=rhtr2020-rhsso-vault-crunchy
# export VAULT_* variables

## Configure Static Secrets

vault secrets enable -path=sso kv-v2

## Create policies for accessing those paths

cat <<EOF > policy.hcl
path "sso/*" {
  capabilities = ["read", "list"]
}
EOF

vault policy write sso-policy policy.hcl

## Create Role 
vault write auth/kubernetes/role/sso \
     bound_service_account_names='*' \
     bound_service_account_namespaces=$NS \
     policies=sso-policy \
     ttl=0s
