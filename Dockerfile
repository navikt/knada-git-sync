FROM alpine/git:latest

RUN git clone https://github.com/navikt/github-app-token-generator.git /github-app-token-generator

RUN apk update && apk add \
    ruby \
    ruby-dev \
    jq \
    make \
    gcc \
    libc-dev

RUN gem install jwt json
