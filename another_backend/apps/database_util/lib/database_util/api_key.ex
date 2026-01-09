defmodule DatabaseUtil.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "api_keys" do
    field(:provider, :string, default: "openai")
    field(:key_hash, DatabaseUtil.Hashed.HMAC)
    field(:encrypted_key, DatabaseUtil.Encrypted.Binary)

    belongs_to(:user, DatabaseUtil.User)

    timestamps(type: :utc_datetime)
  end

  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:user_id, :provider, :encrypted_key])
    |> validate_required([:user_id, :provider, :encrypted_key])
    # Before saving must hash the raw key to fill key_hash
    |> prepare_key_hash()
    |> unique_constraint(:user_id)
    |> unique_constraint(:key_hash)
  end

  defp prepare_key_hash(changeset) do
    if key = get_change(changeset, :encrypted_key) do
      {:ok, hashed} = DatabaseUtil.Hashed.HMAC.dump(key)
      put_change(changeset, :key_hash, hashed)
    else
      changeset
    end
  end
end
