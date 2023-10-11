defmodule JorinMe.DevServer do
  use Plug.Router

  plug(Plug.Logger, log: :info)
  plug(Plug.Static, at: "/", from: "output")
  plug(:match)
  plug(:dispatch)

  get "/*path" do
    path = Path.join([File.cwd!(), "output"] ++ conn.path_info ++ ["index.html"])
    send_file(conn, 200, path)
  end

  # TODO: port 404 page
  match _ do
    send_resp(conn, 404, "oops")
  end
end
