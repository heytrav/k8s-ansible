FROM ubuntu:16.04

RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN touch /etc/apt/sources.list.d/kubernetes.list && \
   echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl

EXPOSE 8001

WORKDIR /opt/k8s
COPY k8s-admin.conf .

CMD ["kubectl", "--kubeconfig", "~/k8s-admin.conf","proxy"]


