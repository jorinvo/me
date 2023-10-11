%{
    title: "Cleaning Up Your Github History",
    description: "If you want to open source a project you don't want it to contain any sensitive data. I would like to share my workflow to achieve this.",
    keywords: ["git", "history", "clean", "delete", "github"],
    archive: true
}
---

At work, we decided to open source one of our projects. Unfortunately it uses a lot of third-parties and we simulated the requests in the tests with real project data. This data contained sensitive user information and we had to make sure to remove this from the repository before we can share the codebase with the world.

In our case, we were able to find out which files contain sensitive data. So, if we remove this file from the repository, we should be ok.

It turns out, there is an amazing tool already to do exactly this job - remove the data from all branches: [bfg-repo-cleaner](https://rtyley.github.io/bfg-repo-cleaner/). The project has really good instructions on it's website. Check it out! Also, don't be scared that `bfg` is written in Scala - You just run the .jar file like any other program.

Here is my workflow for reference:

1. Clone your raw repository

```
git clone --mirror https://github.com/your/project.git
```

2. Use `bfg` for each file you want to delete from the history.
(Make sure you use the right path to the `bfg.jar` file.)

```
java -jar bfg.jar -D file1.js project.git
java -jar bfg.jar -D file2.txt project.git
java -jar bfg.jar -D file3.rb project.git
```

3. Clean the reference logs and optimize the project again

```
cd project.git/
git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

4. Push your changes to Github

```
git push
```

Depending on your project size, you get a lot of output while pushing.

Updates like the following mean a successful overwrite of a branch:

```
+ 1432fa3...acc2dc1 master -> master (forced update)
```

Unfortunately, you might also see something like this:

```
! [remote rejected] refs/pull/100/head -> refs/pull/100/head (deny updating a hidden ref)
```

The problem is that Github also saves branches after you merged, closed and deleted them. You have no way to modify those branches. The only way you can really remove them is by deleting the repository. Be careful because everyone who cloned or forked your project still has access to the original data. And keep in mind that you also loose all stars, issues and so on when deleting a project.

However, at least you have a clean repository. And if you push this to a new Github project you can savely open source it!

