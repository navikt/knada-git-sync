#!/bin/sh
set -e

ARGLEN=$#
if [ $ARGLEN -lt 3 ]
then
    REPO=$GIT_SYNC_REPO
    REF=$GIT_SYNC_BRANCH
    DIR=$GIT_SYNC_ROOT
else
    REPO=$1
    REF=$2
    DIR=$3
fi

if [ -e /keys/PRIVATE_KEY ]
then
    export GITHUB_REPOSITORY="${REPO}"

    # get-installation-access-token.sh stores the fetched access token in a file referenced by the env GITHUB_OUTPUT
    # so we must create this file
    touch /tmp/token
    export GITHUB_OUTPUT=/tmp/token

    for i in {1..3}
    do
        /github-app-token-generator/get-installation-access-token.sh "$(cat /var/run/secrets/github/PRIVATE_KEY)" "$(cat /var/run/secrets/github/APP_ID)" && break || echo "retrying fetching access token in 5 seconds..."; sleep 5
    done
    TOKEN=$(tail -1 /tmp/token)
    TOKEN=${TOKEN#"token="}
    CREDS="x-access-token:$TOKEN"
else
    CREDS=""
fi

for i in {1..3}
do 
    git clone --depth=1 --quiet "https://$CREDS@github.com/$REPO" -b "$REF" "$DIR" && break || echo "retrying in 5 seconds..."; sleep 5
done

sleep 2
