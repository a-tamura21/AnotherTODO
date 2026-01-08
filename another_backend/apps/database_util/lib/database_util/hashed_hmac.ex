defmodule DatabaseUtil.Hashed.HMAC do
  use Cloak.Ecto.HMAC, otp_app: :database_util

  @impl Cloak.Ecto.HMAC
  def init(config) do
    # Fetch the key derived in DatabaseUtil.Vault.init/1
    case DatabaseUtil.Vault.search_key() do
      nil ->
        # If the Vault isn't ready yet, we return the config as-is.
        # Cloak will only error if it tries to 'dump' while secret is still nil.
        {:ok, config}

      key ->
        config =
          Keyword.merge(config,
            algorithm: :sha256,
            secret: key
          )

        {:ok, config}
    end
  end
end
