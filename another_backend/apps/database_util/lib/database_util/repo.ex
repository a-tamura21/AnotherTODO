defmodule DatabaseUtil.Repo do
  use Ecto.Repo,
    otp_app: :database_util,
    adapter: Ecto.Adapters.Postgres
end
