+++
date = "2018-01-31"
title = "Wikireducer : Following Wikipedia links"
description = "Wikireducer, Wikio"
tags = [
  "blog",
  "project",
]
+++

## Overview

I came back from the gym last week and a few of my friend's made the following
claim:

> Following the first link of a Wikipedia article always leads to philosophy.

It was a very strong claim, but one that can be verified easily.

## Solution

My previous scraping projects and linksearchers have been exclusively in Python.
I love Python, but I have been exposed to Ruby over the past months and decided
this project would be a good fit. 5 months ago I made
[Seguridad](https://github.com/dang3r/seguridad) to learn how to make a Ruby gem
and increase my exposure to the language. I was hoping to do the same this time.

## Implementation

I implemented the solution using the Ruby standard library for making requests
and [Nokogiri](https://github.com/sparklemotion/nokogiri) for parsing HTML.

I created a small library called `Wikio` containing a couple of functions that
would make solving the problem straightforward. 

#### Problem 1 : How do I retrieve the wikipedia page for a given term?

Wikipedia provides a nice API for retrieving this information. You can view more
documentation at
[MediaWiki](https://www.mediawiki.org/wiki/API:Main_page#The_endpoint).

#### Problem 2 : How do I retrieve the first link on a given Wikipedia article?

First, I had to find the corresponding HTML for a page.

![Doggo](/img/wiki-dog.png)
  
The above image represents the HTML for the main body of the Wikipedia article.

![CloserLook](/img/wiki-html.png)

At a closer look, at `p` elements underneath the `div.mw-parser-output` element
contain the content of the article. Specifically, all anchors either directly
under those `p` elements, or underneath a `p` then an `i` contained article
links. This can be converted to an `xpath` expression for use by Nokogiri.

![Italics](/img/wiki-italics.png)

## Wikio, Wikireducer

Wikireducer is a script that performs the search solving the problem. Wikio is
the helper library powering it. The code can be found
[here](https://github.com/dang3r/wikio)!

An example of using `Wikireducer` is below:

```
# Finding the number of steps
$ gem install wikio
$ wikireducer --dst=Knowledge Cat Dog
Searching for https://en.wikipedia.org/wiki/Knowledge
$ wikireducer --dst=Knowledge Cat Dog
Searching for https://en.wikipedia.org/wiki/Knowledge
https://en.wikipedia.org/wiki/Dog -> https://en.wikipedia.org/wiki/Dog
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Cat
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Fur
https://en.wikipedia.org/wiki/Dog -> https://en.wikipedia.org/wiki/Canis
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Hair
https://en.wikipedia.org/wiki/Dog -> https://en.wikipedia.org/wiki/Genus
...
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Knowledge in 14 steps
https://en.wikipedia.org/wiki/Dog -> https://en.wikipedia.org/wiki/Knowledge in 14 steps
```

Sometimes, cycles are detected when performing a search

```
# Identifying Cycles
$ gem install wikio
$ wikireducer --dst=Philosophy Dog Cat
Searching for https://en.wikipedia.org/wiki/Philosophy
https://en.wikipedia.org/wiki/Dog -> https://en.wikipedia.org/wiki/Dog
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Cat
https://en.wikipedia.org/wiki/Dog -> https://en.wikipedia.org/wiki/Canis
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Fur
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Hair
https://en.wikipedia.org/wiki/Dog -> https://en.wikipedia.org/wiki/Genus
....
Cycle detected for https://en.wikipedia.org/wiki/Dog at node
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Ancient_Greek_language
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Greek_language
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Modern_Greek
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Colloquialism
https://en.wikipedia.org/wiki/Cat -> https://en.wikipedia.org/wiki/Vernacular
Cycle detected for https://en.wikipedia.org/wiki/Cat at node
```

You can install Wikio+Wikireducer via `gem install wikio`.

## Conclusion

This was a fun experiment to delve into Ruby with.

Writing this post also made me realize I wish I could caption images in
markdown. There is probably a way using raw HTML+CSS, but I will leave that for
a future post.

## Resources

- http://guides.rubygems.org/make-your-own-gem/
- https://stackoverflow.com/questions/27457977/searching-wikipedia-using-api
