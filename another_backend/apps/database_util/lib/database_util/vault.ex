defmodule DatabaseUtil.Vault do
  use Cloak.Vault, otp_app: :database_util

  @impl GenServer
  def init(config) do
    # 1. Fetch Master Key (from Dotenvy via runtime.exs)
    master =
      Application.fetch_env!(:database_util, :db_encryption)[:master_key]
      |> Base.decode64!()

    # 2. Derive distinct keys for Encryption and Searching
    enc_key = :crypto.mac(:hmac, :sha256, master, "encryption_v1")
    idx_key = :crypto.mac(:hmac, :sha256, master, "blind_index_v1")

    # 3. Store both in the Vault's configuration
    config =
      config
      |> Keyword.put(:ciphers, default: {Cloak.Ciphers.AES.GCM, tag: "GCM", key: enc_key})
      |> Keyword.put(:hmac_secret, idx_key)

    {:ok, config}
  end

  # This function must be OUTSIDE of the init/1 function
  def search_key do
    # Cloak 1.1+ table name
    table = DatabaseUtil.Vault.Config

    if :ets.whereis(table) != :undefined do
      case :ets.lookup(table, :config) do
        [{:config, vault_config}] -> vault_config[:hmac_secret]
        _ -> nil
      end
    else
      nil
    end
  end
end
