defmodule GameOfLiveViewWeb.BoardLive.Index do
  use GameOfLiveViewWeb, :live_view
  alias GameOfLiveViewWeb.BoardLive.Cell
  alias GameOfLiveView.Board

  @shout_ms 1000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      schedule_tick()
    end

    {
      :ok,
      socket
      |> assign(:board, Board.empty())
      |> assign(:cell_pids, %{})
    }
  end

  def handle_info({:cell_status, pos, alive, cell_pid}, socket) do
    new_board =
      socket.assigns.board
      |> Board.update_board(pos, alive)

    {
      :noreply,
      socket
      |> assign(board: new_board)
      |> update(:cell_pids, fn pids -> pids |> Map.put(pos, cell_pid) end)
    }
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule_tick()
    board = socket.assigns.board
    cell_pids = socket.assigns.cell_pids

    for col <- 0..18, row <- 0..18 do
      cell = {col, row}
      fate = board |> Board.will_live?(cell)

      ## TODO: make this kill the cell, and remove from dom somehow
      # send_update(Cell, id: "#{col}-#{row}", alive: fate)
      send(cell_pids[cell], {:alive, fate})
    end

    {:noreply, socket}
  end

  def schedule_tick() do
    Process.send_after(self(), :tick, @shout_ms)
  end
end
