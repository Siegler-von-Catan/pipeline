#!/usr/bin/env python3


# This script is supposed to test if the asset folder is in
# the correct shape to be used by the server


import sys
import json
import os


if len(sys.argv) != 2:
    print("Provide only one argument, the datasets/asset folder")
    exit(1)

datasets_folder = sys.argv[1]

# Check if datasets.json is present and if each entry is correctly
# pointing towards a dataset folder
f = open(os.path.join(datasets_folder, "datasets.json"))
datasets = json.load(f)

for dataset_name in datasets.keys():
    dataset = datasets[dataset_name]

    if "title" not in dataset:
        print("Dataset missing title")

    if "description" not in dataset:
        print("Dataset missing description")

    if "license" not in dataset:
        print("Dataset missing license")

    dataset_folder = os.path.join(datasets_folder, dataset_name)

    if not os.path.isfile(
        os.path.join(datasets_folder, "dataset_thumbs", dataset_name + ".png")
    ):
        print(f"Dataset #{dataset_name} is missing a thumb")

    items_file = open(os.path.join(dataset_folder, "items.json"))
    items = json.load(items_file)

    for index, item in enumerate(items, start=0):
        path_heightmap = os.path.join(dataset_folder, "heightmap", str(index) + ".png")
        path_stl = os.path.join(dataset_folder, "stl", str(index) + ".stl")
        path_original = os.path.join(dataset_folder, "original", str(index) + ".png")

        for expected_file in [path_heightmap, path_stl, path_original]:
            if not os.path.isfile(expected_file):
                print(f"File is missing: #{expected_file}")
                print("Exiting...")
                exit(1)

print("Looks good to me, good job!")
