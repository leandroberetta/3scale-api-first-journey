# Jenkins

Create a Jenkins instance with the official template as follows:

```bash
oc create namespace jenkins

oc new-app --template=openshift/jenkins-persistent -p VOLUME_CAPACITY=50Gi -n jenkins
```

After the installation, import the image representing the 3scale toolbox Jenkins agent (see the Dockerfile for details):

```bash
oc import-image jenkins-3scale-toolbox-agent:latest --from=quay.io/leandroberetta/jenkins-3scale-toolbox-agent:0.17.1 --confirm

oc label is jenkins-3scale-toolbox-agent role=jenkins-slave -n jenkins
```

Finally, run a test pipeline to check the 3scale toolbox:

```bash
oc apply -f pipeline.yaml -n jenkins
```