defmodule GameOfLiveViewWeb.BoardLive.Index do
  use GameOfLiveViewWeb, :live_view
  alias GameOfLiveViewWeb.BoardLive.Cell
  alias GameOfLiveView.Board

  @moduledoc """
  Plan:
   - board generates randomized cell life
   - for each cell life, surrounding cells become zombies (unless already alive)
   -
  """

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
      |> assign(:width, 40)
      |> assign(:height, 40)
    }
  end

  @impl true
  def handle_info({:shout, {col, row}}, socket) do
    IO.inspect("Cell #{col}-#{row} shouted!")

    # TODO: Make it so
    # - if cell exists, send it lifeforce
    # - if cell dead, create one as 'zombie', send it lifeforce
    {:noreply, socket}
  end

  def schedule_tick() do
    # progress
    # everyone shouts
    Phoenix.PubSub.broadcast(MyApp.PubSub, @shout_topic, {:shout, col, row})
    # reschedule
    Process.send_after(self(), :tick, @shout_ms)
  end
end
