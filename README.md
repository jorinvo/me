# jorin / home

This site is built with [Jekyll](https://jekyllrb.com/), [Pixyll](https://www.pixyll.com) and [Github Pages](https://pages.github.com/).
Thank you open source!



## Licensing

- The code can is [MIT](https://github.com/johnotander/pixyll/blob/master/LICENSE.txt) as [Pixyll](https://www.pixyll.com).
- My articles inside [`_posts/`](https://github.com/jorinvo/home/tree/gh-pages/_posts) are [CC](https://github.com/jorinvo/home/blob/gh-pages/LICENSE.txt).



## Development

### Installing Jekyll

By using the Github Pages gem I can be sure it looks the same as in production.
Just run:

    bundle


### Jekyll Serve

    bundle exec jekyll serve --watch

This ensures the same setup as on Github Pages is used locally.
Now you can navigate to [`localhost:4000`](http://localhost:4000) in your browser to see the site.


## Build

    bundle exec jekyll build --destination some_folder
