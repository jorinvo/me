defmodule JorinMe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: JorinMe.DevServer, scheme: :http, port: 3000}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JorinMe.Supervisor]
    Logger.info("serving dev site at http://localhost:3000")
    Supervisor.start_link(children, opts)
  end
end
