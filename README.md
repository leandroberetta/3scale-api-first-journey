# API First Journey with 3scale

Work in progress.

This repository aims to be a reference to implement an API First approach using technologies like Apicurio, Microcks and 3scale on OpenShift.

## Journey

1. Design the API with Apicurio
2. Mock the API in Microcks
4. Implement the API with Camel (importing the OpenAPI spec)
5. Deploy the API to DEV environment and test it with a Jenkins pipeline
6. Release the API to STAGE environment and import the API to 3scale with a Jenkins pipeline using the 3scale toolbox
7. Test the API and test/configure 3scale features (limiting, security among other things)
8. If everything is ok, promote the API to PROD with the Jenkins pipeline (the promotion deploys the API and the 3cale definitions in PROD)

## Installation

1. [Microcks](./microcks/README.md)
2. [Apicurio](./apicurio/README.md)
3. [Jenkins](./jenkins/README.md)