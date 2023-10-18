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

export GITHUB_REPOSITORY="${REPO}"

# get-installation-access-token.sh stores the fetched access token in a file referenced by the env GITHUB_OUTPUT
# so we must create this file
touch /tmp/token
export GITHUB_OUTPUT=/tmp/token

/github-app-token-generator/get-installation-access-token.sh "$(cat /keys/PRIVATE_KEY)" "$(cat /keys/APP_ID)"
TOKEN=$(tail -1 /tmp/token)
TOKEN=${TOKEN#"token="}

for i in {1..3}
do 
    git clone --quiet "https://x-access-token:$TOKEN@github.com/$REPO" -b "$REF" "$DIR" && break || echo "retrying in 5 seconds..."; sleep 5
done

sleep 2
