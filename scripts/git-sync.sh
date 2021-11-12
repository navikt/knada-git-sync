#!/bin/sh
set -e

REPO=$1
REF=$2
DIR=$3
SYNC_TIME=$4

export GITHUB_REPOSITORY="${REPO}"

TOKEN=$(/bin/bash /github-app-token-generator/get-installation-access-token.sh "$(cat /keys/PRIVATE_KEY)" "$(cat /keys/APP_ID)") && \
TOKEN="${TOKEN#::set-output name=token::}"

# if .git exists, we already have cloned the repo (see git-clone)
if [ ! -d "$DIR/.git" ]; then
    git clone -v "https://x-access-token:$TOKEN@github.com/$REPO" "$DIR"
fi

# to break the infinite loop when we receive SIGTERM
trap "exit 0" TERM

cd "$DIR"
while true; do
  git fetch origin "$REF";
  git reset --hard "origin/$REF";
  git clean -fd;
  date;
  sleep "$SYNC_TIME";
done
