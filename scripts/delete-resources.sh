helm delete pg
oc delete deploy postgresql-db-backrest-shared-repo
oc delete deploy postgresql-db
oc delete service postgresql-db-backrest-shared-repo
oc delete service postgresql-db
oc delete pvc postgresql-db-pgbr-repo
oc delete pvc postgresql-db
oc delete job postgresql-db-stanza-create
