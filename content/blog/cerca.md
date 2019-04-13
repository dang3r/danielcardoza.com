+++
date = "2017-11-18"
title = "Cerca : Search a website's links"
description = "Cerca - Search website links"
tags = [
  "blog",
  "project",
]
+++

## Overview

I recently had a problem where I wanted to verify that a website:

- did not link to a given website on a blacklist
- did not return non 2XX status codes for a given route

Although there are many utilities you can probably piece together to solve this
problem, I decided to make my own utility `Cerca` (which is Catalan for search).

## Problem

Given a website URL, search the website for all external and internal
links. Follow all internal links while not revisiting past links.

## Solution

I decided to use the following approach:

0. Initialize a queue with the website's root (eg. https://wikipedia.com)
1. Pop a URL off the queue.
2. Retrieve the webpage and extract all links on the page if it was an internal
   link.
3. Add each link to a queue, if it had not been seen.
4. Repeat until the queue is empty.

To do this, I decided to use the following:

- Language : [Python3](https://docs.python.org/3/) 
- HTML library : [BeautifulSoup4](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)
- Algorithm : Use simple BFS with a queue

The code can be seen [here](https://github.com/dang3r/cerca)!

As part of this project, I also wanted to learn how to make a python module. It
is actually fairly straightforward:

```
# Contains your package information
$ vim setup.py
# Create the distribution, register a python account, and upload
$ python3.6 setup.py sdist register upload
```

## Example

```
$ pip3 install cerca
$ cerca https://google.ca
200 https://google.ca
200 https://google.ca/preferences?hl=en
200 https://google.ca/advanced_search?hl=en&authuser=0
404 https://google.ca/language_tools?hl=en&authuser=0
200 https://google.ca/intl/en/ads/
200 https://google.ca/services/
200 https://google.ca/intl/en/about.html
...
```

## Resources

- https://marthall.github.io/blog/how-to-package-a-python-app/
- https://docs.python.org/3/
- https://www.crummy.com/software/BeautifulSoup/bs4/doc/
