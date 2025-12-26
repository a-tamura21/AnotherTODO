defmodule DatabaseUtil.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:email_hashed, :string, null: false)
      add(:email_encrypted, :binary, null: false)
      add(:password_hahsed, :string, null: false)
      add(:encrypted_user_key, :binary, null: false)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:users, [:email_hashed]))
  end
end
