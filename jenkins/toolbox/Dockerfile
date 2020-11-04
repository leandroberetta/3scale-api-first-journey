FROM registry.redhat.io/openshift4/ose-jenkins-agent-base

RUN wget https://github.com/3scale/3scale_toolbox_packaging/releases/download/v0.17.1/3scale-toolbox-0.17.1-1.el7.x86_64.rpm && \
    rpm -i 3scale-toolbox-0.17.1-1.el7.x86_64.rpm && \
    rm 3scale-toolbox-0.17.1-1.el7.x86_64.rpm
