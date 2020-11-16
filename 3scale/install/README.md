# 3scale

## Prerequisites

* 3scale 2.9 Operator installed in 3cale namespace
* OpenShift Container Storage 4 (for the RWX storage needed by 3scale)

## Installation

```bash
oc create namespace 3scale

export WILDCARD_DOMAIN=apps.pepper.87ff.sandbox1678.opentlc.com

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