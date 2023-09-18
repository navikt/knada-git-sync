#!/bin/sh
set -e

if [[ -z "${GIT_SYNC_ONE_TIME}" ]]; then
  /git-sync.sh
else
  /git-clone.sh
fi
