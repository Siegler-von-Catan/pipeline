#!/usr/bin/env bash

set -euo pipefail

export DATA_DIR="data/images"
export OUT_DIR="data/out"

export EXTRACTION_DIR="sealExtraction"
export SFS_DIR="ShapeFromShading"
export DMSTL_DIR="displacementMapToStl"

process_single() {
    set -euo pipefail

    local base_file
    base_file="$(basename --suffix=.jpg "$1")"
    local extracted_file="$OUT_DIR/seal-$base_file.png"
    local output_file="$OUT_DIR/shape-$base_file.png"
    local pp_output_file="$OUT_DIR/processed-shape-$base_file.png"
    local shape_file="$OUT_DIR/map-$base_file.stl"

    if [ -f "$extracted_file" -a -f "$output_file" -a -f "$pp_output_file" -a -f "$shape_file" ]; then
        echo "Skipping \"$1\""
        return
    else
        echo "Processing \"$1\""
    fi

    sealExtraction \
        -o "$extracted_file" \
        "$1"
    sealconvert3d \
        -o "$output_file" \
        "$extracted_file"
    convert \
        "$output_file" \
        -equalize \
        -statistic NonPeak 10 \
        -blur 8 \
        -negate \
        -flop \
        -rotate 270 -crop -10-10 -rotate 90 -fill white -draw "color 0,0 floodfill" \
        "$pp_output_file"

    blender \
	-noaudio \
        --background \
        "$(pwd)/$DMSTL_DIR/src/empty.blend" \
        --python "$(pwd)/$DMSTL_DIR/src/displacementMapToStl.py" \
        -- \
        "$(pwd)/$pp_output_file" \
        "$(pwd)/$shape_file"
}

# Prerequisites

if [ ! -d "$EXTRACTION_DIR" ]; then
    printf "Did not find specified sealExtraction location \"%s\".\nDid you initialize the git submodules?\n" "$EXTRACTION_DIR"
    exit 1
fi

if [ ! -d "$SFS_DIR" ]; then
    printf "Did not find specified ShapeFromShading location \"%s\".\nDid you initialize the git submodules?\n" "$SFS_DIR"
    exit 1
fi

if [ ! -d "$DMSTL_DIR" ]; then
    printf "Did not find specified displacmentMapToStl location \"%s\".\nDid you initialize the git submodules?\n" "$SFS_DIR"
    exit 1
fi

if [ ! -d "$DATA_DIR" ]; then
    printf "\"%s\" does not exist!\n" "$DATA_DIR"
    exit 1
fi

#if [ -d "$OUT_DIR" ]; then
#    printf "\"%s\" already exists! Delete it or change the output directory\n" "$OUT_DIR"
#    exit 1
#else
    mkdir -p "$OUT_DIR"
#fi

export -f process_single

find "$DATA_DIR" -type f -name '*.jpg' \
    -print0 | \
        parallel \
            -j 4 \
            -0 \
            --eta \
            --halt now,fail=1 \
            process_single {}
