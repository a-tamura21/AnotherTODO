defmodule DatabaseUtil.Repo.Migrations.Tasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false)
      add(:task_id, :uuid, primary_key: true)
      add(:title, :binary, null: false)
      add(:content_encrypted, :binary, null: false)
      add(:content_hashed, :string, null: false)
      add(:is_complete, :boolean, null: false, default: false)
      add(:due_date, :utc_datetime)
      add(:priority, :integer)

      timestamps(type: :utc_datetime)
    end

    create(index(:tasks, [:user_id]))
  end
end
