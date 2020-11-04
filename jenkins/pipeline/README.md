# Pipeline

```bash
oc apply -f api-pipeline.yaml -n jenkins
```

```bash
oc new-project api-dev
oc new-project api-test
oc new-project api-prod
```

```bash
oc adm policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n api-dev
oc adm policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n api-test
oc adm policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n api-prod
```