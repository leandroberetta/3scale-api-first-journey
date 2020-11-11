# Keycloak

Work in progress.

## Installation

### Prerequisites

* Keycloak Operator installed in sso namespace

```bash
oc create namespace sso

echo "apiVersion: keycloak.org/v1alpha1
kind: Keycloak
metadata:
  name: 3scale-keycloak
  labels:
    app: sso
spec:
  externalAccess:
    enabled: true
  extensions:
    - >-
      https://github.com/aerogear/keycloak-metrics-spi/releases/download/1.0.4/keycloak-metrics-spi-1.0.4.jar
  instances: 1" | oc create -f - -n sso
```

## Self-signed Certificate Configuration in Zync QUE

```bash
KEYCLOAK_FQDN=keycloak-sso.apps.pepper.40cd.sandbox45.opentlc.com

echo -n | openssl s_client -connect $KEYCLOAK_FQDN:443 -servername $KEYCLOAK_FQDN -showcerts | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > keycloak.pem

oc rsh dc/zync-que /bin/bash -c "cat /etc/pki/tls/cert.pem" > zync.pem 2>&1

cat keycloak.pem >> zync.pem

oc create configmap zync-pem --from-file=zync.pem -n 3scale

oc set volume dc/zync-que --add --overwrite --name=zync-pem --mount-path=/etc/pki/tls/zync/zync.pem --sub-path=zync.pem --source='{"configMap":{"name":"zync-pem"}}' -n 3scale

oc set env dc/zync-que SSL_CERT_FILE=/etc/pki/tls/zync/zync.pem -n 3scale

oc rsh dc/zync-que /bin/bash -c "curl -v https://$KEYCLOAK_FQDN/auth/realms/master"

rm keycloak.pem zync.pem
```