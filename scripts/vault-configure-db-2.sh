#!/bin/bash

# export NS 
export NS=rhtr2020-rhsso-vault-crunchy
# export VAULT_* variables
# export DB_* variables
export DB_HOST="sso-postgresql.${NS}"
export DB_DATABASE="sso"

vault secrets enable database

vault write database/config/postgresql \
     plugin_name=postgresql-database-plugin \
     connection_url="postgresql://{{username}}:{{password}}@${DB_HOST}:5432/postgres?sslmode=disable" \
     allowed_roles=postgresql-role \
     username="postgres" \
     password="password"

cat <<EOF>rotation.sql
ALTER USER "{{name}}" WITH PASSWORD '{{password}}';
EOF

vault write database/static-roles/postgresql-role \
        db_name=postgresql \
        rotation_statements=@rotation.sql \
        username="ssouser" \
        rotation_period=86400
