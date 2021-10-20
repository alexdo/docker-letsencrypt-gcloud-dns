FROM debian:bullseye-slim
LABEL maintainer="Alexander Dormann <alexander@dormann.me>"

RUN apt-get update && apt-get install -y wget apt-transport-https tar xz-utils curl gnupg
RUN wget https://github.com/go-acme/lego/releases/download/v4.5.3/lego_v4.5.3_linux_amd64.tar.gz \
    && tar xvfz lego_v4.5.3_linux_amd64.tar.gz \
    && mv lego /usr/bin/lego

RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk-bullseye main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
        && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
        && apt-get update && apt-get install -y google-cloud-sdk

ENV GCE_PROJECT=example-project
ENV GCE_DOMAIN="example.com"
ENV EMAIL=certmaster@example.com
ENV DOMAINS=example.com,test.example.com
ENV RENEW_DAYS=30


COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME /certstore
VOLUME /gcloud-service-account.json

CMD [ "/entrypoint.sh" ]