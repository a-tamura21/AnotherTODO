defmodule DatabaseUtil.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string, null: false)
      add(:password, :string, null: false)
      add(:timezone, :string)
    end

    create(unique_index(:users, [:email]))
  end
end
