defmodule DatabaseUtil.Hashed.HMAC do
  # This makes this module a valid Ecto.Type
  use Cloak.Ecto.HMAC, otp_app: :database_util

  @impl Cloak.Ecto.HMAC
  def init(config) do
    # Fetch the blind index key we derived in your Vault
    # Note: Use a function or GenServer call to get the derived key at runtime
    config =
      Keyword.merge(config,
        algorithm: :sha256,
        secret: DatabaseUtil.Vault.search_key()
      )

    {:ok, config}
  end
end
