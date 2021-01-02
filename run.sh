#!/usr/bin/env bash

set -euo pipefail

VENV_DIR="$(pwd)/.venv"
DATA_DIR="data/SiegelOhneRisse"
OUT_DIR="data/out"

EXTRACTION_DIR="sealExtraction"
SFS_DIR="ShapeFromShading"

setup() {
    python3 -m venv "$VENV_DIR"
    source "${VENV_DIR}/bin/activate"
    pip install -r "$EXTRACTION_DIR/requirements.txt"
    pip install -r "$SFS_DIR/requirements.txt"
}

process_single() {
    #local extracted_file="$(mktemp extracted_seal_XXXXXX.jpg)"
    local base_file
    base_file="$(basename --suffix=.jpg "$1")"
    local extracted_file="$OUT_DIR/seal-$base_file.png"
    local output_file="$OUT_DIR/shape-$base_file.png"
    python3 "$EXTRACTION_DIR/sealExtraction/main.py" \
        -o "$extracted_file" \
        "$1"
    python3 "$SFS_DIR/shapefromshading/main.py" \
        -o "$output_file" \
        "$extracted_file"
}

# Prerequisites

if [ ! -d "$EXTRACTION_DIR" ]; then
    printf "Did not find specified sealExtraction location \"%s\".\nHave you initialized the git submodules?\n" "$EXTRACTION_DIR"
    exit 1
fi

if [ ! -d "$SFS_DIR" ]; then
    printf "Did not find specified ShapeFromShading location \"%s\".\nHave you initialized the git submodules?\n" "$SFS_DIR"
    exit 1
fi

if [ ! -d "$DATA_DIR" ]; then
    printf "\"%s\" does not exist!\n" "$DATA_DIR"
    exit 1
fi

if [ -d "$OUT_DIR" ]; then
    printf "\"%s\" already exists! Delete it or change the output directory\n" "$OUT_DIR"
    exit 1
else
    mkdir -p "$OUT_DIR"
fi

if [ ! -d "$VENV_DIR" ]; then
    printf "Virtual environment missing in \"%s\". Setting it up now\n" "$VENV_DIR"
    setup
else
    printf "Using virtual environment in \"%s\"\n" "$VENV_DIR"
    source "${VENV_DIR}/bin/activate"
fi


find "$DATA_DIR" -type f -name '*.jpg' \
    -print0 |
    while IFS= read -r -d '' line; do
        process_single "$line"
    done
