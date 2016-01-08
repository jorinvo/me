# jorin / home

This site is built with [Hugo](https://gohugo.io/), [Pixyll](https://www.pixyll.com).
Thank you open source!



## License

- The code can is [MIT](https://github.com/johnotander/pixyll/blob/master/LICENSE.txt) as [Pixyll](https://www.pixyll.com).
- My articles [`_posts/`](https://github.com/jorinvo/home/tree/master/_posts) are [CC](https://github.com/jorinvo/home/blob/master/LICENSE.txt).



## Development

### Installing Jekyll

By using the Github Pages gem I can be sure it looks the same as in production.
Just run:

    bundle


### Server

    hugo server

This ensures the same setup as on Github Pages is used locally.
Now you can navigate to [`localhost:1313`](http://localhost:1313) in your browser to see the site.


## Build

    bundle exec jekyll build --destination some_folder
