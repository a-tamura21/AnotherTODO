defmodule DatabaseUtil.Hashed.HMAC do
  use Cloak.Ecto.HMAC, otp_app: :database_util

  @impl Cloak.Ecto.HMAC
  def init(config) do
    # Ensure search_key() actually returns a binary key
    case DatabaseUtil.Vault.search_key() do
      secret when is_binary(secret) and secret != "" ->
        config =
          Keyword.merge(config,
            algorithm: :sha256,
            secret: secret
          )

        {:ok, config}

      _ ->
        # Log a warning so you know why hashing is failing
        require Logger
        Logger.error("HMAC initialization failed: Vault search_key returned nil or empty.")
        :error
    end
  end
end
