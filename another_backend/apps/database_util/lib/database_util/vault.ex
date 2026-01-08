defmodule DatabaseUtil.Vault do
  use(Cloak.Vault, otp_app: :database_util)

  @impl true
  def init(config) do
    # Fetch the key that Dotenvy loaded into your app config in runtime.exs
    master_key = Application.fetch_env!(:database_util, :db_encryption)[:master_key]

    config =
      Keyword.put(config, :ciphers,
        # Base.decode64! assumes your .env key is a base64 string
        default: {Cloak.Ciphers.AES.GCM, tag: "GCM", key: Base.decode64!(master_key)}
      )

    {:ok, config}
  end
end
