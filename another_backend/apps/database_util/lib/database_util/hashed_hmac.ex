defmodule DatabaseUtil.Hashed.HMAC do
  use Cloak.Ecto.HMAC, otp_app: :database_util

  @impl Cloak.Ecto.HMAC
  def init(config) do
    # Fetch key dynamically; if nil, Ecto will fail gracefully during 'dump'
    # instead of crashing during compilation/initialization.
    config =
      Keyword.merge(config,
        algorithm: :sha256,
        secret: DatabaseUtil.Vault.search_key()
      )

    {:ok, config}
  end
end
