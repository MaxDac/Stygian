defmodule Stygian.Repo do
  use Ecto.Repo,
    otp_app: :stygian,
    adapter: Ecto.Adapters.Postgres
end
