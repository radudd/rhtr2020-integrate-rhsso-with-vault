#!/bin/bash

## Configure Dynamic Secrets for DB

# export NS 
export NS=rhtr2020-rhsso-vault-crunchy
# export VAULT_* variables
# export DB_* variables
export DB_HOST="postgresql-db.${NS}"
export DB_DATABASE="sso"

vault secrets enable database

vault write database/config/postgresql \
     plugin_name=postgresql-database-plugin \
     connection_url="postgresql://{{username}}:{{password}}@${DB_HOST}:5432/postgres?sslmode=disable" \
     allowed_roles=postgresql-role \
     username="postgres" \
     password="password"

vault write database/roles/postgresql-role \
    db_name=postgresql \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
	GRANT ALL PRIVILEGES ON DATABASE ${DB_DATABASE} TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"

## Configure Static Secrets

vault secrets enable -path=sso kv-v2

## Create policies for accessing those paths

cat <<EOF > policy.hcl
path "sso/*" {
  capabilities = ["read", "list"]
}
path "database/creds/*" {
  capabilities = ["read", "list"]
}
EOF

vault policy write sso-policy policy.hcl

## Create Role 
vault write auth/kubernetes/role/sso \
     bound_service_account_names='*' \
     bound_service_account_namespaces=\'$NS\' \
     policies=sso-policy \
     ttl=0s

# Label Namespace
oc label namespace rhtr2020-vault-rhsso vault.hashicorp.com/agent-webhook=enabled
