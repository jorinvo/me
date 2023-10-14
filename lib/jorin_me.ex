defmodule JorinMe do
  @moduledoc """
  All functionality for rendering and building the site
  """

  require Logger
  alias JorinMe.Content
  alias JorinMe.Render

  @output_dir "./output"

  def assert_uniq_page_ids!(pages) do
    ids = pages |> Enum.map(& &1.id)
    dups = Enum.uniq(ids -- Enum.uniq(ids))

    if dups |> Enum.empty?() do
      :ok
    else
      raise "Duplicate pages: #{inspect(dups)}"
    end
  end

  def build_pages() do
    pages = Content.all_pages()
    all_posts = Content.all_posts()
    active_posts = Content.active_posts()
    about_page = Content.about_page()
    not_found_page = Content.not_found_page()
    reads = Content.get_reads()
    assert_uniq_page_ids!(pages)
    render_file("index.html", Render.index(%{posts: active_posts}))
    write_file("index.xml", Render.rss(all_posts))
    write_file("sitemap.xml", Render.sitemap(pages))
    render_file("404.html", Render.page(not_found_page))
    render_file(about_page.html_path, Render.page(about_page))
    render_file("archive/index.html", Render.archive(%{posts: all_posts}))

    for post <- all_posts do
      render_file(post.html_path, Render.post(post))
    end

    for {path, target} <- Content.redirects() do
      render_file(path, Render.redirect(%{target: target}))
    end

    for page <- reads do
      render_file(page.html_path, Render.reads(page))
    end

    render_file("reads/index.html", Render.reads_index(%{pages: reads}))

    :ok
  end

  def write_file(path, data) do
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
