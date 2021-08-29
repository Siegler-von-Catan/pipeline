#!/usr/bin/env python3


# This script is supposed to test if the asset folder is in
# the correct shape to be used by the server


import sys
import os
from PIL import Image

if len(sys.argv) != 5:
    print(
        "Provide 4 arguments, the image folder, the output folder, and the maximum height and widths"
    )
    exit(1)

datasets_folder = sys.argv[1]
output_folder = sys.argv[2]

if not os.path.isdir(output_folder):
    os.mkdir(output_folder)

max_size = [int(sys.argv[3]), int(sys.argv[4])]

files = os.listdir(datasets_folder)

for file in files:
    print(file)
    try:
        with Image.open(os.path.join(datasets_folder, file)) as image:
            image.thumbnail(max_size)
            image.save(os.path.join(output_folder, file))
    except Exception as e:
        print(e)
        print("Failed file:")
        print(file)
