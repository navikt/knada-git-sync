FROM alpine/git:latest

ENV AIRFLOW_USER 50000

RUN git clone https://github.com/navikt/github-app-token-generator.git /github-app-token-generator

RUN apk update && apk add \
    ruby \
    ruby-dev \
    jq \
    make \
    gcc \
    libc-dev \
    bash \
    curl

RUN gem install jwt json

COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/git-clone.sh /git-clone.sh
COPY scripts/git-sync.sh /git-sync.sh

RUN chmod +x /git-clone.sh /git-sync.sh

RUN adduser -u ${AIRFLOW_USER} airflow -D

USER ${AIRFLOW_USER}

ENTRYPOINT [ "/bin/sh", "/entrypoint.sh" ]
