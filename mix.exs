defmodule JorinMe.MixProject do
  use Mix.Project

  def project do
    [
      app: :jorin_me,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {JorinMe.Application, []}
    ]
  end

  defp deps do
    [
      {:nimble_publisher, "~> 1.1.0"},
      {:makeup_elixir, "~> 1.0.0"},
      {:makeup_js, "~> 0.1.0"},
      {:makeup_html, "~> 0.2.0"},
      {:phoenix_live_view, "~> 1.1.2"},
      {:xml_builder, "~> 2.4.0"},
      {:yaml_elixir, "~> 2.12.0"},
      {:html_sanitize_ex, "~> 1.4.3"},
      {:tailwind, "~> 0.3.1"},
      {:bandit, "~> 1.8.0"},
      {:exsync, "~> 0.2"},
      {:credo, "~> 1.7.1"}
    ]
  end
end
