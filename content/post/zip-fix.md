---
date: 2016-01-16T21:20:44+07:00
title: Fix Broken Zip Files
---

Here's a quick-tip to fix a broken zip file.<!--more-->


I backed up some files on a USB drive a while ago.

Since this were quite a lot of files and most of them were plain text, I put them in an archive.

Now, I needed to open one of the files again.

But I wasn't able to unzip it.
I got an error that the files doesn't seem to be a proper archive file.
Luckily there was a quick way to fix the broken archive:

```sh
zip -FF file.zip --out fixed.zip && unzip fixed.zip
```

It didn't restore all of the files but most of them are working.
