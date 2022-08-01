defmodule GameOfLiveViewWeb.BoardLive.Index do
  use GameOfLiveViewWeb, :live_view
  alias GameOfLiveViewWeb.BoardLive.CellComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
