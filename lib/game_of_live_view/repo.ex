defmodule GameOfLiveView.Repo do
  use Ecto.Repo,
    otp_app: :game_of_live_view,
    adapter: Ecto.Adapters.Postgres
end
