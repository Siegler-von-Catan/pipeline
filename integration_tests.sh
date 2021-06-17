#!/usr/bin/env bash

set -euo pipefail

mkdir -p data
cd data

cp test_images/ data/ -r

./docker_run.sh

echo "Finished"
