---
date: 2016-01-19T21:22:20+07:00
description: I will explain a quick-tip to open files in your editor after you found them using grep.
title: Search with Grep and Edit Files
---

Sometimes `grep` can be the fastest tool to find something.

If you're already on the command line, `grep` is there.

With `grep 'text' files` you can search for some text in certain files.

Using [wild cards](https://duckduckgo.com/?q=unix+wild+cards&t=canonical)
can be really flexible to select the right files.

As soon as you found the right files and you want to edit them now,
you can pass the `-l` flag to `grep`.
This just `l`ists the files instead of showing the matching line.

Now, you can pass this list of files to your editor:

```sh
grep -l 'remember' */appinfo/info.xml | xargs vim
```

Even if it takes some time to learn the commands,
a shell can be really helpful for daily tasks.

It gives you a lot of flexibility and opportunities to automate things.
