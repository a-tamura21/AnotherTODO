defmodule DatabaseUtil.Repo.Migrations.Tasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add(:user_id, references(:users, on_delete: :delete_all), null: false)
      add(:title, :string, null: false)
      add(:description, :text, null: false)
      add(:is_complete, :boolean, null: false, default: false)
      add(:due_date, :utc_datetime)
      add(:priority, :integer)

      timestamps(type: :utc_datetime)
    end

    create(index(:tasks, [:user_id]))
  end
end
