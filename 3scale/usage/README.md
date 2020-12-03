# API Usage

The next steps show how to consume the API in the TEST and PROD tenants. 

NOTE: Before trying this, a pipeline needs to be run at least one time to create the 3scale definitions and deploy the application across the environments.

### TEST

```bash
export WILDCARD_DOMAIN=apps.pepper.87ff.sandbox1678.opentlc.com

export TEST_TENANT_ADMIN_URL=${$(oc get secret test-tenant-secret -o json -n 3scale | jq -r .data.adminURL | base64 --decode -)#https://}
export TEST_TENANT_ACCESS_KEY=$(oc get secret test-tenant-secret -o json -n 3scale | jq -r .data.token | base64 --decode -)

3scale remote add test-tenant https://$TEST_TENANT_ACCESS_KEY@$TEST_TENANT_ADMIN_URL --insecure
3scale application-plan apply test-tenant songs basic -n "Basic" --default --insecure
3scale application create test-tenant john songs basic songs --application-id=songs --user-key 123456789 --description=Songs --insecure

curl -k "https://songs-music-test-apicast-staging.$WILDCARD_DOMAIN/api/songs?user_key=123456789"
```

### PROD

```bash
export WILDCARD_DOMAIN=apps.pepper.87ff.sandbox1678.opentlc.com

export PROD_TENANT_ADMIN_URL=${$(oc get secret prod-tenant-secret -o json -n 3scale | jq -r .data.adminURL | base64 --decode -)#https://}
export PROD_TENANT_ACCESS_KEY=$(oc get secret prod-tenant-secret -o json -n 3scale | jq -r .data.token | base64 --decode -)

3scale remote add prod-tenant https://$PROD_TENANT_ACCESS_KEY@$PROD_TENANT_ADMIN_URL --insecure
3scale application-plan apply prod-tenant songs basic -n "Basic" --default --insecure
3scale application create prod-tenant john songs basic songs --application-id=songs --user-key 123456789 --description=Songs --insecure

curl -k "https://songs-music-prod-apicast-production.$WILDCARD_DOMAIN/api/songs?user_key=123456789"
```
