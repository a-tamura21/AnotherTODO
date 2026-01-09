defmodule DatabaseUtil.Repo.Migrations.CreateUserSummaries do
  use Ecto.Migration

  def change do
    create table(:user_summaries, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false)

      # Tracks the state of all tasks combined
      add(:aggregated_hash, :binary, null: false)

      # The encrypted AI summary text
      add(:summary_encrypted, :binary, null: false)
      add(:model_used, :string)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:user_summaries, [:user_id]))
  end
end
