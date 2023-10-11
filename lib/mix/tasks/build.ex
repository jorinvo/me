defmodule Mix.Tasks.Build do
  use Mix.Task
  @impl Mix.Task
  def run(_args) do
    JorinMe.build_all()
  end
end
