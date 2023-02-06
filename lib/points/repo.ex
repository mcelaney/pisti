defmodule Points.Repo do
  use Ecto.Repo,
    otp_app: :points,
    adapter: Ecto.Adapters.Postgres
end
