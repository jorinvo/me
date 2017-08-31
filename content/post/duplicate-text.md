---
date: 2016-07-02T16:14:30+02:00
description: |
  This is a quick explanation of a way to repeat text in Unix using `seq` and `xargs`.
title: Duplicating Text With Unix Tools
---

For a recent task I needed to create a long text document for testing purposes.

In this case it was enough to just copy the same text multiple times.

After a quick research I found a neat way of doing this on the command line.

Let's assume we have a file called **short.txt** and want to copy its content **100** times into a file called **long.txt**.
We can do this with the following line:

``` sh
seq 100 | xargs -Inone cat short.txt > long.txt
```

Let me explain:

1. **seq 100** outputs the numbers from **1** to **100** each on one line.
2. **|** forwards all the output of the first command to the following one.
3. **xargs** gets all the output from **seq** and takes another command as argument which it will run for each line of its input.
4. **-Inone** sets the **-I** *flag* for **xargs** with a value of *"none"*. This will replace the string *"none"* in the following command with the line of input **xargs** passes to it. By setting **I** to *"none"* and not using *"none"* anywhere in the following command, we tell **xargs** to just ignore the previous input.
5. **cat short.txt** is the command we give as argument to **xargs**. This command will be run **100** times now. **cat** stands for *concatenate*. We give it a file name as argument and all it does is to output the content of this file.
6. With **seq 100 | xargs -Inone cat short.txt** so far, we output **100** times the content of **short.txt**.
7. The last part, **> long.txt**  takes this output now and *redirects* it into the file **long.txt**.

That's all.

There are many other Unix tools you could use to achieve this task, but I like this solution in particular because it uses only really basic Unix tools. There is no need to learn some more cryptic, tool specific syntax like with **sed** or **printf**.
