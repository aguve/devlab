#!/bin/bash
CONTAINER="devlab-tools"
WORKDIR="/workspace"

if [ -n "$1" ]; then
  WORKDIR="$1"
fi

docker exec -it -w "$WORKDIR" "$CONTAINER" bash
