defmodule GameOfLiveViewWeb.PageControllerTest do
  use GameOfLiveViewWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Boards"
  end
end
