# Songs

## OpenShift

```bash
oc new-project api-dev

oc new-build redhat-openjdk18-openshift:1.8~https://github.com/leandroberetta/3scale-api-first-journey.git \
    --context-dir=api \
    --name songs \
    -n api-dev

oc apply -k ./api/manifests/overlays/dev -n api-dev
```

## Local

```bash
export USER=right-lyrics && \
export PASS=right-lyrics && \
export DB=right-lyrics && \

docker run --name songs-postgresql -d \
    -p 5432:5432 \
    -e POSTGRESQL_ADMIN_PASSWORD=${PASS} \
    -e POSTGRESQL_USER=${USER} \
    -e POSTGRESQL_PASSWORD=${PASS} \
    -e POSTGRESQL_DATABASE=${DB} \
    registry.access.redhat.com/rhscl/postgresql-96-rhel7

mvn spring-boot:run
```