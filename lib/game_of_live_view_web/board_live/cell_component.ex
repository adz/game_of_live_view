defmodule GameOfLiveViewWeb.BoardLive.CellComponent do
  use GameOfLiveViewWeb, :live_component

  @impl true
  def mount(socket) do
    alive = connected?(socket) && Enum.random(0..2) == 1
    {:ok, socket |> assign(:alive, alive)}
  end

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:width, 40)
      |> assign(:height, 40)
      |> assign_style()
    }
  end

  @impl true
  def handle_event("toggle", _, socket) do
    {:noreply, socket |> assign(alive: !socket.assigns.alive)}
  end

  defp assign_style(%{assigns: %{alive: is_alive}} = socket) do
    assign(socket, :style, get_style(is_alive))
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
