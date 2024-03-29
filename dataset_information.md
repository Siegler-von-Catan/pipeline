# Preamble

This document is to describe how the different dataset for FabSeal were generated, so that we can easier keep track of how they were crafted,
and also are able to reproduce the datasets if necessary.


# Siegelsammlung Arnold Gruhn

The lido files can be downloaded over the CodingDavinci-Website.
Using retrieve-data, the image files can then be downloaded, and the items.json can be generated using the lido2JSON script.

# Great Britain Pennies (pennies_gbr)

This was harvested from the kenom dataset.
As all of the pennies were from one instituion, I downloaded everything from that institution using
```
oai-harvest --set "objekttyp:Muenze" -p lido  --set "institution:DE-MUS-163517" https://www.kenom.de/oai/
```
and then further filtered using only files that contained the keywords ```penny``` and ```Britannien```.

This allowed to run the pipeline, with the additionall ```--coin``` switch for the sealExtraction.


# Chinese Coins (china)
This was harvested from the kenom dataset.
All pennies where from the "Stiftung Moritzburg Halle, Kunstmuseum des Landes Sachsen-Anhalt",
for scraping, we used

```
oai-harvest --set "objekttyp:Muenze" -p lido  --set "institution:DE-MUS-805518" https://www.kenom.de/oai/
```

It was then filtered for only coins from the song-Dynastie, which are only ±400.

```
grep -iRl "song-dynastie" ./ | xargs -I '{}' cp '{}' ../lido/   
```

Retrieving the data was then possible using our retrive-data script.
```
./retrieve-data.py ../Kenom_Scrape/china/lido/ ../Kenom_Scrape/china/images/ -j 8 --no_exception
```

License is CC BY-NC-SA 3.0, so with displaying metadata the license should be fine.


# Heller from Sachen (heller) (cancelled)

This was harvested from the kenom dataset.
All pennies where from the "Landesmusum für Vorgeschichte Halle",
for scraping, we used

```
oai-harvest --set "objekttyp:Muenze" -p lido  --set "institution:DE-MUS-805310" https://www.kenom.de/oai/
```

Stopped mining this after I saw license is No-Derivatives, which I don't know works for our use case.


# Gemmen (gemmen)

This dataset is originally called Goetter und Helden im Miniaturformat and can be downloaded from the Coding DaVinci Site.
It unfortunatley does not have lido data, but only a csv file, so additional preprocessing for reading in the data will be necessary.

Copyright is CC BY-SA 4.0, so should be fine.

# Siegelmarken of the veikosarchive (schools)
I just copied the html from wikimedia out of the browser and used this ripgrep command to filter out the files:

```rg '(?<=href.)".*?"' html_copy.html -Po --no-line-number > images_links.txt```

Getting the real image file link works something like this in python

```
for l in lines:
  r = requests.get("https://commons.wikimedia.org" + l.replace("\n","").replace('"',''))
  soup = BeautifulSoup(r.content, 'html.parser')
  image_link = soup.find('div', attrs={'class':'fullMedia'}).find('a').get('href')
  print(image_link)
```
By this, we can create a list which contains the real image link, whic can then be downloaded using, for example,
```
wget -i {link_file}
```
Some of the image files had problematic names, as they contained '-' or '.' characters, which I removed by a bulk rename in ranger (but use just whatever you prefer).


