#!/bin/bash
CONTAINER="devlab-opencode"
WORKDIR="/workspace"

if [ -n "$1" ]; then
  WORKDIR="$1"
fi

docker exec -it -w "$WORKDIR" "$CONTAINER" sh
