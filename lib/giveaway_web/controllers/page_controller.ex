defmodule GiveawayWeb.PageController do
  use GiveawayWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
