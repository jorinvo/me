# jorin.me - Jorin's personal blog

This site is generated as static files via custom code using [Elixir](https://elixir-lang.org/) and hosted on Github pages.

After using [Hugo](https://gohugo.io/) for nearly a decade, I decided to take things in my own hands.
With the current setup I am in complete control over the rendering and do not have to learn a custom static site generator.
All used tooling are common Elixir ecosystem packages.

You can read more about the setup in my [Moving the blog to Elixir](https://jorin.me/moving-the-blog-to-elixir/) post.

## Structure

- `pages/` contains the markdown and YAML content I regularly publish
- `assets/` contains static content
- `lib/` contains the code generating the side
- `output/` is where the generated files are rendered


## Running

- `mix deps.get` to install dependencies
- `mix compile` compiles code and generates the site during the compile step. This runs on commits using a Github Action.
- `iex -S mix` runs a dev server serving the side for local development


## Acknowledgement

Thanks to [fly.io's post on SSG using Elixir](https://fly.io/phoenix-files/crafting-your-own-static-site-generator-using-phoenix/) for helping me getting started.


## License

[![Creative Commons Attribution-ShareAlike 3.0 Unported License](https://licensebuttons.net/l/by-sa/3.0/80x15.png)](https://creativecommons.org/licenses/by-sa/3.0/)

The content is licensed under the [Creative Commons Attribution-ShareAlike 3.0 Unported License](https://creativecommons.org/licenses/by-sa/3.0/). The code is licensed under the [MIT license](https://opensource.org/licenses/MIT).
