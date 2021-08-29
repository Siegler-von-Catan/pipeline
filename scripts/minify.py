#!/usr/bin/env python3

# This script is supposed to test if the asset folder is in
# the correct shape to be used by the server


import sys
import json
import os
import shutil

if len(sys.argv) != 3:
    print("Provide three arguments, the datasets/asset folder, and the folder to copy stuff into, and the maximum number of elements")
    exit(1)

datasets_folder = sys.argv[1]
minified_datasets_folder = sys.argv[2]

os.mkdir(minified_dataset_folder)
shutil.copyfile(
        os.path.join(datasets_folder, "datasets.json"),
        os.path.join(minified_datasets_folder, "datasets.json")
        )

max_elements = int(sys.argv[3])

f = open(os.path.join(datasets_folder, "datasets.json"))
datasets = json.load(f)
f.close()

for dataset_name in datasets.keys():
    dataset = datasets[dataset_name]

    dataset_folder = os.path.join(datasets_folder, dataset_name)
    minified_dataset_folder = os.path.join(minified_datasets_folder, dataset_name + "_" + max_elements)
    os.mkdir(minified_dataset_folder)

    os.mkdir(os.path.join(minified_dataset_folder, "heightmap")
    os.mkdir(os.path.join(minified_dataset_folder, "original")
    os.mkdir(os.path.join(minified_dataset_folder, "stl")


    items_file = open(os.path.join(dataset_folder, "items.json"))
    items = json.load(items_file)

    minified_items = []

    for index, item in enumerate(items, start=1):
        if index > max_elements:
            continue

        minified_items.append(item)

        path_heightmap = os.path.join(dataset_folder, "heightmap", str(index) + ".png")
        path_stl = os.path.join(dataset_folder, "stl", str(index) + ".stl")
        path_original = os.path.join(dataset_folder, "original", str(index) + ".png")

        new_path_heightmap = os.path.join(minified_dataset_folder, "heightmap", str(index) + ".png")
        new_path_stl = os.path.join(minified_dataset_folder, "stl", str(index) + ".stl")
        new_path_original = os.path.join(minified_dataset_folder, "original", str(index) + ".png")

        shutil.copyfile(path_heightmap, new_path_heightmap)
        shutil.copyfile(path_stl, new_path_stl)
        shutil.copyfile(path_original, new_path_original)

    with open(os.path.join(minified_datasets_folder, "items.json"), 'w') as items:
        items.write(json.dumps(minified_items))





print("Looks good to me, good job!")
