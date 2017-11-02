FROM debian:stretch-slim
LABEL maintainer="Alexander Dormann <alexander@dormann.me>"

RUN apt-get update && apt-get install -y wget apt-transport-https tar xz-utils curl gnupg
RUN wget https://github.com/xenolf/lego/releases/download/v0.4.1/lego_linux_amd64.tar.xz \
    && tar xf lego_linux_amd64.tar.xz \
    && mv /lego_linux_amd64 /usr/bin/lego

RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk-stretch main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
        && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
        && apt-get update && apt-get install -y google-cloud-sdk

ENV GCE_PROJECT=example-project
ENV GCE_DOMAIN="example.com"
ENV EMAIL=certmaster@example.com
ENV DOMAINS=example.com,test.example.com

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /certstore
VOLUME /gcloud-service-account.json

CMD [ "/entrypoint.sh" ]