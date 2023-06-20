defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller
  require Logger

  def index(conn, _params) do
    root = File.cwd!()
    dev_index_path = Path.join(root, "frontend")
    _prod_index_path = Path.join(root, "dist")

    contents = File.read!(Path.join(dev_index_path, "index.html"))

    conn
    |> put_resp_content_type("text/html", "utf-8")
    |> send_resp(200, contents)
  end
end
