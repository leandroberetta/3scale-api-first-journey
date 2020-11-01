# Microcks

The recommended way to install Microcks is with the Operator using [this](https://microcks.io/documentation/installing/operator/) documentation as a reference.

First, create a namespace for Microcks:

```bash
oc create namespace microcks
```

Then, install the Microcks operator from OperatorHub (in microcks namespace):

![microcks](./images/microcks1.png)

Wait for the installation to end:

![microcks](./images/microcks2.png)

After the installation, create the following CR:

```bash
echo "apiVersion: microcks.github.io/v1alpha1
kind: MicrocksInstall
metadata:
  name: microcks
spec:
  name: microcks
  version: 1.0.0
  microcks:
    replicas: 1
  postman:
    replicas: 1
  features:
    async:
      enabled: false
  keycloak:
    install: true
    persistent: true
    volumeSize: 1Gi
  mongodb:
    install: true
    persistent: true
    volumeSize: 2Gi" | oc apply -f - -n microcks
```

Finally, verify that all the pods are running.

![microcks](./images/microcks3.png)





```bash
oc set env dc/apicurio-studio-api APICURIO_MICROCKS_API_URL=https://microcks-microcks.apps.nano.80bd.sandbox847.opentlc.com/api -n apicurio
oc set env dc/apicurio-studio-api APICURIO_MICROCKS_CLIENT_ID=microcks-serviceaccount -n apicurio
oc set env dc/apicurio-studio-api APICURIO_MICROCKS_CLIENT_SECRET=ab54d329-e435-41ae-a900-ec6b3fe15c54 -n apicurio

oc set env dc/apicurio-studio-ws APICURIO_MICROCKS_API_URL=https://api-first-microcks-microcks.apps.nano.80bd.sandbox847.opentlc.com/api -n apicurio
oc set env dc/apicurio-studio-ws APICURIO_MICROCKS_CLIENT_ID=microcks-serviceaccount -n apicurio
oc set env dc/apicurio-studio-ws APICURIO_MICROCKS_CLIENT_SECRET=ab54d329-e435-41ae-a900-ec6b3fe15c54 -n apicurio

oc set env dc/apicurio-studio-ui APICURIO_UI_FEATURE_MICROCKS=true -n apicurio
```