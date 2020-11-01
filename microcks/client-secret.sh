
export MICROCKS_KEYCLOAK_ADMIN=$(oc get secret api-first-microcks-keycloak-admin -o json -n microcks | jq -r .data.username | base64 --decode -)
export MICROCKS_KEYCLOAK_PASSWORD=$(oc get secret api-first-microcks-keycloak-admin -o json -n microcks | jq -r .data.password | base64 --decode -)
export TOKEN=$(curl -k https://api-first-microcks-keycloak-microcks.apps.nano.80bd.sandbox847.opentlc.com/auth/realms/master/protocol/openid-connect/token -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=password&username=$MICROCKS_KEYCLOAK_ADMIN&password=$MICROCKS_KEYCLOAK_PASSWORD&client_id=admin-cli" | jq -r .access_token)
export CLIENT_ID=$(curl -k  https://api-first-microcks-keycloak-microcks.apps.nano.80bd.sandbox847.opentlc.com/auth/admin/realms/microcks/clients -H "Content-Type: application/json" -H  "Authorization: bearer $TOKEN" | jq -r '.[] | select(.clientId == "microcks-serviceaccount").id')
export CLIENT_SECRET=$(curl -k https://api-first-microcks-keycloak-microcks.apps.nano.80bd.sandbox847.opentlc.com/auth/admin/realms/microcks/clients/$CLIENT_ID/client-secret -H "Content-Type: application/json" -H  "Authorization: bearer $TOKEN" | jq -r .value)
