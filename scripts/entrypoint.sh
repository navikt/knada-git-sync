#!/bin/sh
set -e

if [[ -z "${GIT_SYNC_ONE_TIME}" ]]; then
  /git-clone.sh
else
  /git-sync.sh
fi
