defmodule DatabaseUtil.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__]}
  schema "tasks" do
    field(:title, :string)
    field(:description, :string)
    field(:is_complete, :boolean, default: false)
    field(:due_date, :utc_datetime)
    field(:priority, :integer, default: 3)

    belongs_to(:user, DatabaseUtil.User)

    timestamps(type: :utc_datetime)
  end

  def task_validate(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :is_complete, :due_date, :priority, :user_id])
    |> validate_required([:title, :description])
    |> validate_inclusion(:priority, 1..5)
  end

  def updatetask_validate(task, task_attrs) do
    task
    # reminder there's no need to cast the id since this is handle by the DB, casting it may cause issues
    |> cast(task_attrs, [:title, :description, :is_complete, :due_date, :priority, :user_id])
    |> validate_inclusion(:priority, 1..5)
  end
end
