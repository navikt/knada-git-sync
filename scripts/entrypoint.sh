#!/bin/sh
set -e

if [[ -z "${SYNC_INTERVAL}" ]]; then
  /git-clone.sh
else
  /git-sync.sh
fi
