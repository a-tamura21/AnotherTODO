defmodule DatabaseUtil.TaskFunctions do
  alias DatabaseUtil.Task
  alias DatabaseUtil.Repo

  def get_all_tasks do
  Task
  |> Repo.all()
  |> Enum.map(fn task ->
    %{
      id: task.id,
      title: DatabaseUtil.Vault.decrypt!(task.title_encrypted),
      content: DatabaseUtil.Vault.decrypt!(task.content_encrypted),
      is_complete: task.is_complete,
      due_date: task.due_date,
      priority: task.priority,
      user_id: task.user_id,
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end)
  |> Jason.encode!()
end

  def create_tasks(task_attrs) do
    # use task schema, task_attrs is a map so an empty map is needed
    %Task{}
    # pass task detials into validation using the task schema then insert
    |> Task.task_validate(task_attrs)
    |> Repo.insert()
  end

  def task_by_id(task_id) do
    task = Repo.get(Task, task_id) |> Repo.preload(:user)
    Jason.encode!(task)
  end

  def update_task(task_attrs) do
    id = Map.get(task_attrs, "task_id") |> String.to_integer()
    #id = task_attrs[:id]
    task = Repo.get(Task, id)

    task
    |> Task.updatetask_validate(task_attrs)
    |> Repo.update()
  end

  def delete_task(%{"task_id" => task_id}) do
    task_id = String.to_integer(task_id)
    task = Repo.get!(Task, task_id)
    Repo.delete(task)
  end
end
