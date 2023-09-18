#!/bin/sh

set -e

ARGLEN=$#
if [ $ARGLEN -lt 3 ]
then
    REPO=$DAG_REPO
    REF=$DAG_REPO_BRANCH
    DIR=$DAG_REPO_DIR
    SYNC_TIME=$SYNC_TIME
else
    REPO=$1
    REF=$2
    DIR=$3
    SYNC_TIME=$4
fi

export GITHUB_REPOSITORY="${REPO}"

# get-installation-access-token.sh stores the fetched access token in a file referenced by the env GITHUB_OUTPUT
# so we must create this file
touch /tmp/token
export GITHUB_OUTPUT=/tmp/token

get_token() {
  echo "Fetch token"
  /github-app-token-generator/get-installation-access-token.sh "$(cat /keys/PRIVATE_KEY)" "$(cat /keys/APP_ID)"
  TOKEN=$(tail -1 /tmp/token)
  TOKEN=${TOKEN#"token="}

  # if .git exists, we already have cloned the repo (see git-clone)
  if [ ! -d "$DIR/.git" ]; then
      git clone --quiet -v "https://x-access-token:$TOKEN@github.com/$REPO" "$DIR"
  else
      git config --global --add safe.directory /dags
      git --git-dir "$DIR/.git" remote set-url origin "https://x-access-token:$TOKEN@github.com/$REPO"
  fi
}

git_pull() {
  git fetch --quiet origin "$REF" && \
  git reset --hard "origin/$REF" && \
  git clean --quiet -fd
}

# to break the infinite loop when we receive SIGTERM
trap "exit 0" TERM

cd "$DIR"
while true; do
  date
  git_pull || get_token
  sleep "$SYNC_TIME"
done
