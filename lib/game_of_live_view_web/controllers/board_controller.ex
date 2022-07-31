defmodule GameOfLiveViewWeb.BoardController do
  use GameOfLiveViewWeb, :controller

  def index(conn, _params) do
    data = %{width: 40, height: 40}
    render(conn, "index.html", data)
  end
end
