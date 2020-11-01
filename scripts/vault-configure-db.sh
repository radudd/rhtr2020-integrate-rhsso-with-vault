#!/bin/bash

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

