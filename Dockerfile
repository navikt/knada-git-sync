FROM alpine/git:latest

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

COPY scripts/git-clone.sh /git-clone.sh
COPY scripts/git-sync.sh /git-sync.sh

RUN git config --global --add safe.directory /dags

RUN chmod +x /git-clone.sh /git-sync.sh
