defmodule GameOfLiveViewWeb.BoardLive.Cell do
  use GameOfLiveViewWeb, :live_view

  @shout_topic "shout"

  # params - from router
  # session - in mount, is from live_render
  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(MyApp.PubSub, @shout_topic)
    end

    {:ok,
     socket
     |> assign(:col, session["col"])
     |> assign(:row, session["row"])
     |> assign(:alive, session["alive"])
     |> assign(:shouts, 0)
     |> assign(:width, 40)
     |> assign(:height, 40)}
  end

  @impl true
  def handle_event("toggle", _, socket) do
    {:noreply, socket |> update(:alive, &(not &1))}
  end

  @impl true
  def handle_info(:shout, socket) do
    %{assigns: %{col: col, row: row}} = socket
    Phoenix.PubSub.broadcast(MyApp.PubSub, @shout_topic, {:cell_shout, col, row})
  end

  @impl true
  def handle_info({:cell_shout, col, row}, socket) do
    %{assigns: %{col: my_col, row: my_row}} = socket

    {:noreply,
     if is_neighbour?({my_col, my_row}, {col, row}) do
       socket |> update(:shouts, fn i -> i + 1 end)
     else
       socket
     end}
  end

  defp is_neighbour?(same_cell, same_cell), do: false

  defp is_neighbour?({my_col, my_row}, {col, row}) do
    is_near(my_col, col) && is_near(my_row, row)
  end

  defp is_near(i, j) do
    i in [j - 1, j, j + 1]
  end

  @impl true
  def handle_info({:age}, socket) do
    %{shouts: shouts, alive: alive, col: col, row: row} = socket.assigns

    if Board.passes_life_rule?(alive, shouts) do
      {
        :noreply,
        socket
        |> assign(:shouts, 0)
        |> assign(:alive, true)
      }

      # How about zomies around me?
      # ... make board assign zombies so it can calculate?
    else
      {:stop, "Died"}
    end
  end

  def handle_info({:alive, fate}, socket) do
    {:noreply, socket |> assign(:alive, fate)}
  end

  # Crappy function to generate inline style -- TODO use css class
  def get_style(is_alive) do
    "stroke-width: 1;" <>
      if is_alive do
        " fill:rgb(0,0,0); stroke: rgb(255,255,255)"
      else
        " fill:rgb(255,255,255); stroke: rgb(210,210,210)"
      end
  end

  # def schedule_tick() do
  #   Process.send_after(self(), :tick, @shout_ms)
  # end
end
