defmodule JorinMe.DevServer do
  use Plug.Router

  plug(Plug.Logger, log: :info)
  plug(Plug.Static, at: "/", from: "output")
  plug(:match)
  plug(:dispatch)

  get "/*path" do
    path = Path.join([File.cwd!(), "output"] ++ conn.path_info ++ ["index.html"])

    if File.exists?(path) do
      send_file(conn, 200, path)
    else
      path = Path.join([File.cwd!(), "output", "404.html"])
      send_file(conn, 404, path)
    end
  end
end
