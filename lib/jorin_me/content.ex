defmodule JorinMe.Content do
  alias JorinMe.Page

  use NimblePublisher,
    build: Page,
    from: "./pages/**/*.md",
    as: :pages,
    highlighters: [:makeup_elixir, :makeup_js],
    earmark_options: [breaks: true]

  def all_posts do
    @pages |> Enum.filter(&(&1.type == :post)) |> Enum.sort_by(& &1.date, {:desc, Date})
  end

  def about_page do
    @pages |> Enum.find(&(&1.id == "about"))
  end
end
