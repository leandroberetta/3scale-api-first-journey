# 3scale

## Installation

```bash
oc create namespace 3scale
```

### Prerequisites

* 3scale 2.9 Operator installed in 3cale namespace
* OpenShift Container Storage 4 (for the RWX storage needed by 3scale)

```bash
export WILDCARD_DOMAIN=apps.pepper.40cd.sandbox45.opentlc.com

echo "apiVersion: apps.3scale.net/v1alpha1
kind: APIManager
metadata:
  name: 3scale-apimanager
spec:
  resourceRequirementsEnabled: false
  system:
    fileStorage:
      persistentVolumeClaim:
        storageClassName: ocs-storagecluster-cephfs
  wildcardDomain: $WILDCARD_DOMAIN" | oc apply -f - -n 3scale
```

## Tenants

### TEST

```bash
echo "apiVersion: v1
kind: Secret
metadata:
  name: admin-test-secret
type: Opaque
stringData:
  admin_password: admin-test" | oc apply -f - -n 3scale

echo "apiVersion: capabilities.3scale.net/v1alpha1
kind: Tenant
metadata:
  name: test-tenant
spec:
  username: admin-test
  systemMasterUrl: https://master.$WILDCARD_DOMAIN
  email: admin-test@songs.com
  organizationName: Songs (TEST)
  masterCredentialsRef:
    name: system-seed
  passwordCredentialsRef:
    name: admin-test-secret
  tenantSecretRef:
    name: test-tenant-secret
    namespace: 3scale" | oc apply -f - -n 3scale
```

### PROD

```bash
echo "apiVersion: v1
kind: Secret
metadata:
  name: admin-prod-secret
type: Opaque
stringData:
  admin_password: admin-prod" | oc apply -f - -n 3scale

echo "apiVersion: capabilities.3scale.net/v1alpha1
kind: Tenant
metadata:
  name: prod-tenant
spec:
  username: admin-prod
  systemMasterUrl: https://master.$WILDCARD_DOMAIN
  email: admin-prod@songs.com
  organizationName: Songs (PROD)
  masterCredentialsRef:
    name: system-seed
  passwordCredentialsRef:
    name: admin-prod-secret
  tenantSecretRef:
    name: prod-tenant-secret
    namespace: 3scale" | oc apply -f - -n 3scale
```

## Importing and promoting the API with 3scale Toolbox manually (Optional)

```bash
export TEST_TENANT_ADMIN_URL=${$(oc get secret test-tenant-secret -o json -n 3scale | jq -r .data.adminURL | base64 --decode -)#https://}
export TEST_TENANT_ACCESS_KEY=$(oc get secret test-tenant-secret -o json -n 3scale | jq -r .data.token | base64 --decode -)

echo "3scale remote add test-tenant https://$TEST_TENANT_ACCESS_KEY@$TEST_TENANT_ADMIN_URL --insecure"
3scale import openapi --insecure -d test-tenant https://raw.githubusercontent.com/leandroberetta/3scale-api-first-journey/master/api/songs.json  --override-private-base-url=http://songs.api-test.svc.cluster.local:8080 -t songs --skip-openapi-validation --default-credentials-userkey=123456789
3scale application-plan apply test-tenant songs basic -n "Basic" --default --insecure
3scale application apply test-tenant 123456789 --account=john --name="Client Application" --description="A client application" --plan=basic --service=songs --insecure
3scale proxy-config promote test-tenant songs --insecure

export PROD_TENANT_ADMIN_URL=${$(oc get secret prod-tenant-secret -o json -n 3scale | jq -r .data.adminURL | base64 --decode -)#https://}
export PROD_TENANT_ACCESS_KEY=$(oc get secret prod-tenant-secret -o json -n 3scale | jq -r .data.token | base64 --decode -)

echo "3scale remote add prod-tenant https://$PROD_TENANT_ACCESS_KEY@$PROD_TENANT_ADMIN_URL --insecure"
3scale copy service -s test-tenant -d prod-tenant -t songs --insecure songs
3scale proxy-config promote prod-tenant songs --insecure
```
