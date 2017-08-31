---
date: 2016-07-04T21:12:57+02:00
title: What Are Your Most Used Shell Commands?
---

I used the Unix shell to get some insight into my most-used shell commands.<!--more-->


If you are curious to see which shell commands you are using the most,
I have a one-liner for you to find out.

<br>

*I tested it on Linux only, but it should work similar on other Unix systems since I only use standard commands.*

*Works fine in Bash and Zsh. If you use Fish, you need to handle the different bahavior of the history command.*

<br>

First, let's see how many entries are in the history:

``` sh
$ history | wc -l
2003
```

Now, let's list the top 20 commands:

``` sh
$ history | cut -c8- | cut -d' ' -f1 | sort | uniq -c | sort -nr | head -n20
    269 e
    242 c
    168 l
    122 npm
     88 p
     71 gst
     65 git
     56 man
     55 history
     49 ..
     35 o
     35 e.
     34 fg
     33 ls
     32 cat
     30 sudo
     30 node
     25 find
     24 t
     22 free
```

1. **cut -c8-** removes the line numbers of **history** output.
2. **cut -d' ' -f1** limits selection to first word in line because we want to ignore command arguments.
3. **sort | uniq -c**  counts all unique commands.
4. **sort -nr** orders lines in reverse numerical order.
5. **head -n20** returns only the first 20 lines.


Interestingly **9** of the first **20** commands are [custom shortcuts](https://github.com/jorinvo/dotfiles/blob/master/bashrc) I created.

<br>

*Bonus:*

To see what ratio the top 20 commands make to the rest of the words, we can combine the above commands with some calculations:

``` sh
$ TOP20=$(history | cut -c8- | cut -d' ' -f1 | sort | uniq -c | sort -nr | head -n20)
$ TOTAL=$(history | wc -l)
$ echo "scale=2; ($(echo "$TOP20" | cut -c1-8 | paste -s -d+)) / $TOTAL" | bc
.74
```

1. Let's save the results of the previous commands in variables **TOP20** and **TOTAL**.
2. **cut -c1-8** gives us only the counts of the previous output.
3. **paste -s -d+** joins all the lines with a "+" in between.
4. **scale=2;** defines how many decimal places the results has.
5. **bc** does the calculation.

Looks like this top 20 commands make up 74% of all commands I use.

<br>
<br>

If you think this was helpful, I would be happy to know your most-used commands and most valuable shortcuts.

I am also happy to hear about improvements and variations you came up with!

