#!/usr/bin/env bash

set -euo pipefail

mkdir -p data
mkdir -p data/images
cp test_images/ data/images -r

./docker-run.sh

echo "Finished running ./docker_run.sh"

base_file=uni_big_greyscale.png

FILE=data/out/seal-$base_file.png
if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist, exiting with error"
    exit 1
fi

FILE=data/out/shape-$base_file.png
if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist, exiting with error"
    exit 1
fi

FILE=data/out/processed-shape-$base_file.png
if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist, exiting with error"
    exit 1
fi

FILE=data/out/map-$base_file.stl
if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist, exiting with error"
    exit 1
fi

echo "Passed everything"
exit 0
