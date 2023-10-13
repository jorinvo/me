defmodule Mix.Tasks.Build do
  @moduledoc """
  Use `mix build` to build site and exit
  """

  use Mix.Task
  @impl Mix.Task
  def run(_args) do
    JorinMe.build_all()
  end
end
