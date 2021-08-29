#!/usr/bin/env python3

# This script can be used to extract information for a list of file links from wikimedia

import sys
import json
import os
import requests
from bs4 import BeautifulSoup


if len(sys.argv) != 3:
    print("Run with two arguments, links file and output file")
    exit(1)

link_file = open(sys.argv[1])

items = []


for link in link_file.readlines():
    r = requests.get(
        "https://commons.wikimedia.org" + link.replace("\n", "").replace('"', "")
    )
    soup = BeautifulSoup(r.content, "html.parser")
    image_link = soup.find("div", attrs={"class": "fullMedia"}).find("a").get("href")
    items.append(image_link)
    print(image_link)


with open(sys.argv[2], "w") as outfile:
    for link in items:
        outfile.write(link + '\n')
