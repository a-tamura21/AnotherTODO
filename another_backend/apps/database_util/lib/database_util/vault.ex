defmodule DatabaseUtil.Vault do
  use Cloak.Vault, otp_app: :database_util

  @impl GenServer
  def init(config) do
    master =
      Application.fetch_env!(:database_util, :db_encryption)[:master_key]
      |> Base.decode64!()

    # Derive keys
    enc_key = :crypto.mac(:hmac, :sha256, master, "encryption_v1")
    idx_key = :crypto.mac(:hmac, :sha256, master, "blind_index_v1")

    config =
      config
      |> Keyword.put(:ciphers, default: {Cloak.Ciphers.AES.GCM, tag: "GCM", key: enc_key})
      |> Keyword.put(:hmac_secret, idx_key)

    {:ok, config}
  end

  # Helper to retrieve the key from Cloak's internal storage
  def search_key do
    # Cloak 1.1+ automatically creates this ETS table
    case :ets.lookup(DatabaseUtil.Vault.Config, :hmac_secret) do
      [{:hmac_secret, key}] -> key
      _ -> nil
    end
  end
end
