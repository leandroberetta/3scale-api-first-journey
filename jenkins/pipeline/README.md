# Pipeline

Create the pipeline to deploy de API across environments:

```bash
oc apply -f api-pipeline.yaml -n jenkins
```

Create the environments:

```bash
oc new-project api-dev
oc new-project api-test
oc new-project api-prod
```

Give permissions to Jenkins ServiceAccount to edit the projects representing the environments:

```bash
oc adm policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n api-dev
oc adm policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n api-test
oc adm policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n api-prod
```

Set some environment variables for 3scale Toolbox to authenticate with the tenants:

```bash
export TEST_TENANT_ADMIN_URL=${$(oc get secret test-tenant-secret -o json -n 3scale | jq -r .data.adminURL | base64 --decode -)#https://}
export TEST_TENANT_ACCESS_KEY=$(oc get secret test-tenant-secret -o json -n 3scale | jq -r .data.token | base64 --decode -)

oc set env bc/api-pipeline TEST_TENANT_REMOTE=https://$TEST_TENANT_ACCESS_KEY@$TEST_TENANT_ADMIN_URL -n jenkins

export PROD_TENANT_ADMIN_URL=${$(oc get secret prod-tenant-secret -o json -n 3scale | jq -r .data.adminURL | base64 --decode -)#https://}
export PROD_TENANT_ACCESS_KEY=$(oc get secret prod-tenant-secret -o json -n 3scale | jq -r .data.token | base64 --decode -)

oc set env bc/api-pipeline PROD_TENANT_REMOTE=https://$PROD_TENANT_ACCESS_KEY@$PROD_TENANT_ADMIN_URL -n jenkins
```
