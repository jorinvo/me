defmodule JorinMe do
  @moduledoc """
  All functionality for rendering and building the site
  """

  require Logger
  alias JorinMe.Content
  use Phoenix.Component
  import Phoenix.HTML

  @output_dir "./output"

  def site_title() do
    "jorin.me"
  end

  def site_description() do
    "Jorin's personal blog on building data and communication systems"
  end

  def site_author() do
    "Jorin Vogel"
  end

  def site_url() do
    "https://jorin.me"
  end

  def site_email() do
    "hi@jorin.me"
  end

  def site_copyright() do
    "This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License."
  end

  def redirects() do
    %{
      "/dirtymoney/index.html" =>
        "https://gist.github.com/jorinvo/3d7f6a60fcede1863fa9f0788b8cc1b4",
      "/feed.xml" => "/index.xml",
      "/rss.xml" => "/index.xml",
      "/feed/index.html" => "/index.xml",
      "/blog/index.html" => "/",
      "/post/index.html" => "/",
      "/posts/index.html" => "/"
    }
  end

  def now() do
    DateTime.now!("Etc/UTC")
  end

  def now_iso() do
    DateTime.to_iso8601(now())
  end

  def date_to_datetime(date) do
    DateTime.new!(date, ~T[06:00:00])
  end

  def format_iso_date(date) do
    date
    |> date_to_datetime()
    |> DateTime.to_iso8601()
  end

  def format_post_date(date) do
    Calendar.strftime(date, "%b %-d, %Y")
  end

  def format_rss_date(date) do
    Calendar.strftime(date, "%a, %d %b %Y %H:%M:%S %z")
  end

  def rss_post_limit() do
    20
  end

  def count_words(text) do
    text |> HtmlSanitizeEx.strip_tags() |> String.split() |> Enum.count()
  end

  def newsletter(assigns) do
    ~H"""
    <div class="newsletter-section">
      <form
        action="https://buttondown.email/api/emails/embed-subscribe/jorin"
        method="post"
        target="popupwindow"
        onsubmit="window.open('https://buttondown.email/jorin', 'popupwindow')"
        class="embeddable-buttondown-form"
      >
        <label for={@input_id}>Get new posts in your inbox:</label>
        <input type="email" name="email" id={@input_id} placeholder="email" />
        <input type="submit" value="subscribe" />
      </form>
    </div>
    """
  end

  def post(assigns) do
    ~H"""
    <.layout
      title={"#{@title} — #{site_title()}"}
      description={@description}
      og_type="article"
      route={@route}
      date={@date}
      keywords={@keywords}
      wordcount={count_words(@description <>" " <> @body)}
    >
      <.newsletter input_id="bd-email-top" />
      <div class="post-header">
        <small class="post-meta"><span class="author">Jorin Vogel - </span><%= format_post_date(@date) %></small>
        <a href={@route}>
          <h1><%= @title %></h1>
        </a>
      </div>
      <article class="post-content">
        <p><%= @description %></p>
        <%= raw @body %>
      </article>
      <.newsletter input_id="bd-email-bottom" />
      <div class="post-footer">
        <img
          src="/images/vo.png"
          alt="Jorin Vogel"
          class="avatar"
          width="64px"
          height="64px"
          style="padding-left: 4px; padding-bottom: 4px; background: black;"
        />
        <p>
        Thanks for reading!
        <br />
        My name is Jorin and I am currently building a new feedback tool.
        <br />
        Feel free to send me a <a href={"mailto:${site_email()}"}>mail</a> or talk to me on <a href="https://twitter.com/intent/user?screen_name=jorinvo">twitter</a>.
          </p>
        </div>
        <footer>
          use github to
          <a href={"https://github.com/jorinvo/me/edit/master/#{@src_path}"}>
            edit the post source
          </a>
          or
          <a href="https://github.com/jorinvo/me/issues">give me feedback</a>
        </footer>
        <script>
          document.querySelectorAll('code').forEach(function(el) {
            el.contentEditable = true
          })
        </script>
      </.layout>
    """
  end

  def index(assigns) do
    ~H"""
    <.layout
      title={site_title()}
      description={site_description()}
      route="/"
      og_type="website"
    >
      <.newsletter input_id="bd-email-top" />
      <div class="posts">
        <a :for={post <- @posts} href={post.route} class="post-link alternate">
          <div class="post">
            <small class="post-meta"><%= format_post_date(post.date) %></small>
            <h2 class="post-title"><%= post.title %></h2>
            <div class="post-summary"><%= post.description %></div>
          </div>
        </a>
      </div>
      <.newsletter input_id="bd-email-bottom" />
      <footer>
        use github to <a href="https://github.com/jorinvo/me/issues">give me feedback</a>
      </footer>
    </.layout>
    """
  end

  def page(assigns) do
    ~H"""
    <.layout
      title={"#{@title} — #{site_title()}"}
      description={@description}
      og_type="website"
      route={@route}
    >
      <div class="post-header">
        <a href={@route}>
          <h1><%= @title %></h1>
        </a>
      </div>
      <article class="post-content">
        <%= raw @body %>
      </article>
        <footer>
          use github to
          <a href={"https://github.com/jorinvo/me/edit/master/#{@src_path}"}>
            edit the page source
          </a>
          or
          <a href="https://github.com/jorinvo/me/issues">give me feedback</a>
        </footer>
    </.layout>
    """
  end

  def layout(assigns) do
    ~H"""
    <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="utf-8" />
          <title><%= @title %></title>
          <meta name="description" content={@description} />
          <meta name="author" content={site_author()} />
          <meta http-equiv="X-UA-Compatible" content="IE=edge" />
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <link href="/index.xml" rel="alternate" type="application/rss+xml" title={site_title()} />
          <meta name="ROBOTS" content="INDEX, FOLLOW" />
          <meta property="og:title" content={@title} />
          <meta property="og:description" content={@description} />
          <meta property="og:type" content={@og_type} />
          <meta property="og:url" content={"#{site_url()}#{@route}"}>
          <meta name="twitter:card" content="summary" />
          <meta name="twitter:title" content={@title} />
          <meta name="twitter:description" content={@description} />
          <meta itemprop="name" content={@title} />
          <meta itemprop="description" content={@description} />
          <%= if @og_type == "article" do %>
            <meta itemprop="datePublished" content={format_iso_date(@date)} />
            <meta itemprop="dateModified" content={format_iso_date(@date)} />
            <meta itemprop="wordCount" content={@wordcount} />
            <meta itemprop="keywords" content={Enum.join(@keywords, ",")} />
            <meta property="article:author" content={site_author()} />
            <meta property="article:section" content="Software" />
            <%= for keyword <- @keywords do %>
              <meta property="article:tag" content={keyword} />
            <% end %>
            <meta property="article:published_time" content={format_iso_date(@date)} />
            <meta property="article:modified_time" content={format_iso_date(@date)} />
          <% end %>
          <link rel="stylesheet" href="/assets/app.css" />
        </head>
        <body>
          <header>
            <div class="social">
              <a href="/">Posts</a>
              <a href="/about">About</a>
              <a type="application/rss+xml" href="/index.xml">RSS</a>
              <a href="https://github.com/jorinvo">Github</a>
              <a href="https://twitter.com/jorinvo">Twitter</a>
              <a rel="me" href="https://mas.to/@jorin">Mastodon</a>
            </div>
          </header>
          <%= render_slot(@inner_block) %>
        </body>
      </html>
    """
  end

  def reads_index(assigns) do
    ~H"""
    <.layout
      title="Reads"
      description="A list of articles I read and recommend."
      og_type="website"
      route="/reads"
    >
      <div class="post-header">
        <a href="/reads">
          <h1>Reads</h1>
        </a>
      </div>
      <article class="post-content">
          <ul class="posts">
            <li :for={page <- @pages}>
              <a href={ page.route } class="post-link">
                <%= page.title %>
              </a>
            </li>
           </ul>
      </article>
        <footer>
          use github to <a href="https://github.com/jorinvo/me/issues">give me feedback</a>
        </footer>
    </.layout>
    """
  end

  def rss(posts) do
    XmlBuilder.element(:rss, %{version: "2.0", "xmlns:atom": "http://www.w3.org/2005/Atom"}, [
      {:channel,
       [
         {:title, site_title()},
         {:link, site_url()},
         {:description, "Recent content on #{site_title()}"},
         {:language, "en-us"},
         {:managingEditor, "#{site_author()} (#{site_email()})"},
         {:webMaster, "#{site_author()} (#{site_email()})"},
         {:copyright, site_copyright()},
         {:lastBuildDate, format_rss_date(now())},
         {:"atom:link",
          %{href: "#{site_url()}/index.xml", rel: "self", type: "application/rss+xml"}}
       ] ++
         for post <- Enum.take(posts, rss_post_limit()) do
           {:item,
            [
              {:title, post.title},
              {:link, site_url() <> post.route},
              {:pubDate, format_rss_date(date_to_datetime(post.date))},
              {:author, "#{site_author()} (#{site_email()})"},
              {:guid, site_url() <> post.route},
              {:description, post.description}
            ]}
         end}
    ])
    |> XmlBuilder.generate()
  end

  def sitemap(pages) do
    XmlBuilder.element(:urlset, [
      {:url,
       [
         {:loc, site_url()},
         {:lastmod, now_iso()}
       ]}
      | for page <- pages do
          {:url,
           [
             {:loc, site_url() <> page.route},
             {:lastmod,
              if page.date do
                format_iso_date(page.date)
              else
                now_iso()
              end}
           ]}
        end
    ])
    |> XmlBuilder.generate()
  end

  def redirect(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en-us">
      <head>
        <title><%= @target%></title>
        <link rel="canonical" href={@target}>
        <meta name="robots" content="noindex">
        <meta charset="utf-8">
        <meta http-equiv="refresh" content={"0; url=#{@target}"}>
      </head>
    </html>
    """
  end

  def assert_uniq_page_ids!(pages) do
    ids = pages |> Enum.map(& &1.id)
    dups = Enum.uniq(ids -- Enum.uniq(ids))

    if dups |> Enum.empty?() do
      :ok
    else
      raise "Duplicate pages: #{inspect(dups)}"
    end
  end

  def reads(assigns) do
    ~H"""
    <.layout
      title={"#{@title} — #{site_title()}"}
      description={@description}
      og_type="website"
      route={@route}
    >
      <div class="post-header">
        <a href={@route}>
          <h1><%= @title %></h1>
        </a>
      </div>
      <article class="post-content">
        <p><%= @description %></p>
        <ul class="hide-list">
          <li :for={link <- @links}>
            <a href={ link["url"] }>
              <img src={"https://www.google.com/s2/favicons?domain=#{ URI.parse(link["url"]).host }"} />
              <%= link["title"] %>
            </a>
          </li>
         </ul>
      </article>
        <footer>
          use github to
          <a href={"https://github.com/jorinvo/me/edit/master/#{@src_path}"}>
            edit the page source
          </a>
          or
          <a href="https://github.com/jorinvo/me/issues">give me feedback</a>
        </footer>
    </.layout>
    """
  end

  def build_pages() do
    pages = Content.all_pages()
    posts = Content.all_posts()
    about_page = Content.about_page()
    not_found_page = Content.not_found_page()
    reads = Content.get_reads()
    assert_uniq_page_ids!(pages)
    render_file("index.html", index(%{posts: posts}))
    write_file("index.xml", rss(posts))
    write_file("sitemap.xml", sitemap(pages))
    render_file("404.html", page(not_found_page))
    render_file(about_page.html_path, page(about_page))

    for post <- posts do
      render_file(post.html_path, post(post))
    end

    for {path, target} <- redirects() do
      render_file(path, redirect(%{target: target}))
    end

    for page <- reads do
      render_file(page.html_path, reads(page))
    end

    render_file("reads/index.html", reads_index(%{pages: reads}))

    :ok
  end

  def write_file(path, data) do
    Logger.info("Writing #{path}")
    dir = Path.dirname(path)
    output = Path.join([@output_dir, path])

    if dir != "." do
      File.mkdir_p!(Path.join([@output_dir, dir]))
    end

    File.write!(output, data)
  end

  def render_file(path, rendered) do
    safe = Phoenix.HTML.Safe.to_iodata(rendered)
    write_file(path, safe)
  end

  def build_all() do
    Logger.info("Clear output directory")
    File.rm_rf!(@output_dir)
    File.mkdir_p!(@output_dir)
    Logger.info("Copying static files")
    File.cp_r!("assets/static", @output_dir)
    Logger.info("Building pages")

    {micro, :ok} =
      :timer.tc(fn ->
        build_pages()
      end)

    ms = micro / 1000
    Logger.info("Pages built in #{ms}ms")
    Logger.info("Running tailwind")
    # Using mix task because it installs tailwind if not available yet
    Mix.Tasks.Tailwind.run(["default", "--minify"])
  end
end
