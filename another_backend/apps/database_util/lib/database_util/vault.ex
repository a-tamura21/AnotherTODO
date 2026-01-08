defmodule DatabaseUtil.Vault do
  use Cloak.Vault, otp_app: :database_util

  @impl GenServer
  def init(config) do
    master =
      Application.fetch_env!(:database_util, :db_encryption)[:master_key]
      |> Base.decode64!()

    # Key Derivation
    enc_key = :crypto.mac(:hmac, :sha256, master, "encryption_v1")
    idx_key = :crypto.mac(:hmac, :sha256, master, "blind_index_v1")

    config =
      config
      |> Keyword.put(:ciphers, default: {Cloak.Ciphers.AES.GCM, tag: "GCM", key: enc_key})
      |> Keyword.put(:hmac_secret, idx_key)

    {:ok, config}
  end

  def search_key do
    # Cloak 1.1+ table name is [YourVault].Config
    table = DatabaseUtil.Vault.Config

    # Check if table exists (avoids crashes during early IEx boot)
    if :ets.whereis(table) != :undefined do
      # 2026 Standard: Cloak stores everything under the :config key
      case :ets.lookup(table, :config) do
        [{:config, vault_config}] -> vault_config[:hmac_secret]
        _ -> nil
      end
    else
      nil
    end
  end
end
