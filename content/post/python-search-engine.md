---
date: 2016-05-25T18:47:44+02:00
description: |
  I wrote an small search engine in Python
  to demonstrate basic concepts of searching.
title: Writing a Search Engine in Python
---

I wrote a little search engine in Python.
The source is over [here](https://github.com/jorinvo/r/blob/master/search.py).

This is only to demonstrate how the basic concepts behind search engines work.

All processing is done in-memory and the algorithms are optimized for readability - no thoughts about performance.

The implementation shows:

- How to crawl and parse websites
- How to create an index
- A way to calculate a primitive [PageRank](https://en.wikipedia.org/wiki/PageRank)
- How to calculate the [cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity) between a query and a document
- And finally, how to combine them to output ranked search results

You can try the script with your own web page and search for some terms.

If you learn best by playing around with code instead of reading about the theory, feel free to try out this module in the Python interpreter and see what all the different functions do.


Here is an example using my own website at time of writing:

(Note that the crawler doesn't follow external links)

```sh
$ python search.py 'ruby go' https://jorin.me
crawled https://jorin.me with 21 links
crawled https://jorin.me/index.xml with 0 links
crawled https://jorin.me/https-for-one-month with 2 links
crawled https://jorin.me/deploy-with-travis-and-git with 2 links
crawled https://jorin.me/grep-and-edit with 2 links
crawled https://jorin.me/zip-fix with 2 links
crawled https://jorin.me/git-cloc with 2 links
crawled https://jorin.me/using-computers-for-good with 2 links
crawled https://jorin.me/encedit with 2 links
crawled https://jorin.me/homework-in-markdown with 2 links
crawled https://jorin.me/internship-in-bangkok with 3 links
crawled https://jorin.me/debug-with-docker-and-boom with 2 links
crawled https://jorin.me/miniflux with 2 links
crawled https://jorin.me/textstat with 2 links
crawled https://jorin.me/clean-git-history with 2 links
crawled https://jorin.me/csv-challenge with 2 links
crawled https://jorin.me/lessons-learned-zudu with 2 links
crawled https://jorin.me/svg-chart with 2 links
crawled https://jorin.me/sierpinski with 2 links
crawled https://jorin.me/convert-videos-rb with 2 links
crawled https://jorin.me/img-filter-in-canvas with 2 links

Number of pages: 21
Terms in index: 1964
Interations for PageRank: 9

Search results for "ruby go":
0.000598  https://jorin.me/index.xml
0.000265  https://jorin.me
0.000206  https://jorin.me/textstat
0.000200  https://jorin.me/convert-videos-rb
0.000078  https://jorin.me/internship-in-bangkok
0.000075  https://jorin.me/https-for-one-month
```

