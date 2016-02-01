---
date: 2015-09-03T20:44:54+07:00
summary: |
  Here I show my workflow to create longer documents using Markdown
  and how to generate a PDF file from it.
title: How to Write Your Homework in Markdown
---

I have to write a 20 pages report for my university.

As part of my procrastination I decided,
I can do better than Microsoft Word or LibreOffice.

First, it is important for me to be able to version-control my writing.
Therefore I write everything in plain text.
This allows me to store everything in Git and back it up easily.

Since I still need some formatting, I write everything in [Markdown][md].
Also, I put every chapter in a separate file to make it easy to navigate around.

Now the only problem left is to get all the content into a nicely formatted PDF file.

I found a nice npm module called [markdown-pdf][markdown-pdf].

The configuration is simple. I have an executable `./build` file that looks like this:

```bash
#!/bin/sh
set -e

# Make sure markdown-pdf is installed
which markdown-pdf &> /dev/null || npm i -g markdown-pdf

# Read all chapters. They are ordered correctly.
# Use a CSS file for styling.
# Generate header and footer for each page.
# Allow custom HTML in Markdown.
markdown-pdf \
  chapters/* \
  --paper-format 'A4' \
  --css-path design/style.css \
  --runnings-path design/header-and-footer.js \
  --out report.pdf \
  --remarkable-options '{ "html": true }'
```

I also created another utility `./watch` to automatically update the PDF file whenever I change any Markdown file.

```bash
#!/bin/sh
set -e

# Works only on Debian based Linux.

# Make sure inotify is available.
which inotifywait &> /dev/null || apt install inotify-tools
# Open PDF
which xdg-open &> /dev/null && xdg-open report.pdf

# Watch style and content files for changes
while inotifywait -e close_write,moved_to,create design chapters
  do ./build
done
```

I use [inotify-tools][inotify] on Linux.
Other platforms have similar tools available.

Now, I see the changes I make to the files automatically updated in the PDF file.
This is especially helpful to optimize formatting and styling.

Also I would like to point out [Butterick’s Practical
Typography][typography] as really nice resource to learn how to make text documents look pleasing.

[md]: http://commonmark.org/
[markdown-pdf]: https://www.npmjs.com/package/markdown-pdf
[inotify]: https://github.com/rvoicilas/inotify-tools
[typography]: http://practicaltypography.com/
