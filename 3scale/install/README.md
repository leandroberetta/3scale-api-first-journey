# 3scale

The recommended way to install 3scale is with the operator.

First, create a namespace for 3scale:

```bash
oc create namespace 3scale
```

Then, install the 3scale operator from OperatorHub (in 3scale namespace) and wait for the installation to end.

After the installation succeeds, create the following CR:

```bash
export WILDCARD_DOMAIN=apps.pepper.b984.sandbox286.opentlc.com

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

NOTE: A PersistentVolume with RWX access is required, the recommended approach is to install OpenShift Container Storage.

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
  email: admin-test@music.com
  organizationName: Music (TEST)
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
  email: admin-prod@music.com
  organizationName: Music (PROD)
  masterCredentialsRef:
    name: system-seed
  passwordCredentialsRef:
    name: admin-prod-secret
  tenantSecretRef:
    name: prod-tenant-secret
    namespace: 3scale" | oc apply -f - -n 3scale
```