defmodule GameOfLiveView.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GameOfLiveView.Repo,
      # Start the Telemetry supervisor
      GameOfLiveViewWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GameOfLiveView.PubSub},
      # Start the Endpoint (http/https)
      GameOfLiveViewWeb.Endpoint
      # Start a worker by calling: GameOfLiveView.Worker.start_link(arg)
      # {GameOfLiveView.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameOfLiveView.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GameOfLiveViewWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
