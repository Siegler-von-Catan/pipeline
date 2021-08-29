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
    r = requests.get("https://commons.wikimedia.org" + link.replace("\n","").replace('"',''))
    soup = BeautifulSoup(r.content, 'html.parser')
    title = soup.find(text="Title:").parent.nextSibling
    print(title)
    items.append(
            {
                "name": title,
                "subjects": [],
                }
            )


with open(sys.argv[2],'w') as outfile:
    outfile.write(json.dumps(items))

