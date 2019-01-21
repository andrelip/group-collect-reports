defmodule GroupCollectWeb.PageController do
  use GroupCollectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
