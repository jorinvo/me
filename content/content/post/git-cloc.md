---
date: 2016-01-15T21:20:44+07:00
summary: Quick-tip to count lines-of-code more accurate
title:  See how many lines a Git project contains
---

Even if lines of code is not an accurate representation of the complexity of a project, it can still be an interesting number to get a feeling for the size of a software project.
To ignore files not tracked my Git (like node\_modules) you can use the following command to see how many lines a git project has:

```sh
git ls-files | xargs cloc
```

Just make sure you have [cloc][cloc] installed.



[cloc]: https://github.com/AlDanial/cloc
