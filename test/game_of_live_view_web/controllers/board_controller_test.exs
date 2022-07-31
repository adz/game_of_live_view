defmodule GameOfLiveViewWeb.BoardControllerTest do
  use GameOfLiveViewWeb.ConnCase

  test "GET /board", %{conn: conn} do
    conn = get(conn, "/board")
    assert html_response(conn, 200) =~ "<svg"
  end
end
