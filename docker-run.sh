#!/usr/bin/env bash

set -euo pipefail

docker build \
	--network host \
	-t fabseal .

docker run \
	--mount type=bind,source="$(pwd)"/data,target=/fabseal/data \
	fabseal

