#!/bin/sh
set -e

REPO=$1
REF=$2
DIR=$3

export GITHUB_REPOSITORY="${REPO}"

TOKEN=$(/bin/bash /github-app-token-generator/get-installation-access-token.sh "$(cat /keys/PRIVATE_KEY)" "$(cat /keys/APP_ID)") && \
TOKEN="${TOKEN#::set-output name=token::}"

git clone "https://x-access-token:$TOKEN@github.com/$REPO" -b "$REF" "$DIR"
