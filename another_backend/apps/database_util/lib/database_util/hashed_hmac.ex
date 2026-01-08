defmodule DatabaseUtil.Hashed.HMAC do
  use Cloak.Ecto.HMAC, otp_app: :database_util

  @impl Cloak.Ecto.HMAC
  def init(config) do
    # 1. Get the derived key from the Vault
    # 2. Provide a fallback so it doesn't crash if called during boot
    secret = DatabaseUtil.Vault.search_key()

    config =
      Keyword.merge(config,
        algorithm: :sha256,
        secret: secret
      )

    {:ok, config}
  end
end
