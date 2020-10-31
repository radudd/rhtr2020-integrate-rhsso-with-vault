#!/bin/bash

# To fix third statement - role assignment

export NS=rhtr2020-rhsso-vault-crunchy

cat <<EOF > policy.hcl
path "sso/*" {
  capabilities = ["read", "list"]
}
path "database/creds/*" {
  capabilities = ["read", "list"]
}
EOF

vault policy write sso-policy policy.hcl

vault write auth/kubernetes/role/sso \
     bound_service_account_names='*' \ 
     bound_service_account_namespaces=${NS} \
     policies=sso-policy \
     ttl=0s

oc label namespace $NS vault.hashicorp.com/agent-webhook=enabled

rm policy.hcl
