defmodule GameOfLiveViewWeb.BoardLive.Cell do
  use GameOfLiveViewWeb, :live_view

  # params - from router
  # session - in mount, is from live_render
  @impl true
  def mount(_params, session, socket) do
    alive = connected?(socket) && Enum.random(0..2) == 1

    {:ok,
     socket
     |> assign(:alive, alive)
     |> assign(:col, session["col"])
     |> assign(:row, session["row"])
     |> tap(&report_to_parent/1)
     |> assign(:width, 40)
     |> assign(:height, 40)}
  end

  defp report_to_parent(s) do
    send(
      s.parent_pid,
      {:cell_status, {s.assigns.col, s.assigns.row}, s.assigns.alive, self()}
    )
  end

  @impl true
  def handle_event("toggle", _, socket) do
    {:noreply, socket |> update(:alive, &(not &1)) |> tap(&report_to_parent/1)}
  end

  @impl true
  def handle_info({:alive, fate}, socket) do
    {:noreply, socket |> assign(:alive, fate) |> tap(&report_to_parent/1)}
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
end
