defmodule GameOfLiveViewWeb.BoardLive.Index do
  use GameOfLiveViewWeb, :live_view
  alias GameOfLiveViewWeb.BoardLive.CellComponent
  alias GameOfLiveView.Board

  @shout_ms 1000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      schedule_tick()
    end

    {:ok, socket |> assign(:board, Board.empty())}
  end

  def handle_info({:cell_status, pos, alive}, socket) do
    new_board =
      socket.assigns.board
      |> Board.update_board(pos, alive)

    {:noreply, assign(socket, board: new_board)}
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule_tick()
    board = socket.assigns.board

    for col <- 0..18, row <- 0..18 do
      cell = {col, row}
      fate = board |> Board.will_live?(cell)
      send_update(CellComponent, id: "#{col}-#{row}", alive: fate)
    end

    {:noreply, socket}
  end

  def schedule_tick() do
    Process.send_after(self(), :tick, @shout_ms)
  end
end
