defmodule DatabaseUtil.Repo.Migrations.CreateApiKeys do
  use Ecto.Migration

  def change do
    create table(:api_keys, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false)

      # The Blind Index for change detection
      add(:key_hash, :binary, null: false)
      # The encrypted key
      add(:encrypted_key, :binary, null: false)

      add(:provider, :string, default: "openai")
      timestamps(type: :utc_datetime)
    end

    create(unique_index(:api_keys, [:user_id]))
    create(unique_index(:api_keys, [:key_hash]))
  end
end
