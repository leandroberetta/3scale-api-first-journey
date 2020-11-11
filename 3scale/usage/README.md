# API Usage

## Prerequisites

* 3scale installed and configured
* A pipeline run finished successfully

## Configuration

The next steps show a basic scenario to consume the API in the TEST and PROD tenants. 

### TEST

```bash
export WILDCARD_DOMAIN=apps.pepper.40cd.sandbox45.opentlc.com
export TEST_TENANT_ADMIN_URL=${$(oc get secret test-tenant-secret -o json -n 3scale | jq -r .data.adminURL | base64 --decode -)#https://}
export TEST_TENANT_ACCESS_KEY=$(oc get secret test-tenant-secret -o json -n 3scale | jq -r .data.token | base64 --decode -)

3scale remote add test-tenant https://$TEST_TENANT_ACCESS_KEY@$TEST_TENANT_ADMIN_URL --insecure
3scale application-plan apply test-tenant songs basic -n "Basic" --default --insecure
3scale application create test-tenant john songs basic songs --application-id=songs --user-key 123456789 --description=Songs --insecure
3scale proxy-config promote test-tenant songs --insecure

curl -k "https://songs-songs-test-apicast-production.$WILDCARD_DOMAIN/api/songs?user_key=123456789"
```

### PROD

```bash
export WILDCARD_DOMAIN=apps.pepper.40cd.sandbox45.opentlc.com
export PROD_TENANT_ADMIN_URL=${$(oc get secret prod-tenant-secret -o json -n 3scale | jq -r .data.adminURL | base64 --decode -)#https://}
export PROD_TENANT_ACCESS_KEY=$(oc get secret prod-tenant-secret -o json -n 3scale | jq -r .data.token | base64 --decode -)

3scale remote add prod-tenant https://$PROD_TENANT_ACCESS_KEY@$PROD_TENANT_ADMIN_URL --insecure
3scale application-plan apply prod-tenant songs basic -n "Basic" --default --insecure
3scale application create prod-tenant john songs basic songs --application-id=songs --user-key 123456789 --description=Songs --insecure
3scale proxy-config promote prod-tenant songs --insecure

curl -k "https://songs-songs-prod-apicast-production.$WILDCARD_DOMAIN/api/songs?user_key=123456789"
```
