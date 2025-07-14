defmodule DatabaseUtil.TaskFunctions do
  alias DatabaseUtil.Task
  alias DatabaseUtil.Repo

  def get_all_tasks do
    Task
    |> Repo.all()
    |> Repo.preload(:user)
    |> Jason.encode!()
  end

  def create_tasks(task_attrs) do
    # use task schema, task_attrs is a map so an empty map is needed
    %Task{}
    # pass task detials into validation using the task schema then insert
    |> Task.task_validate(task_attrs)
    |> Repo.insert()
  end

  def task_byID(task_id) do
    task = Repo.get(Task, task_id) |> Repo.preload(:user)
    Jason.encode!(task)
  end

  def update_task(task_attrs) do
    id = task_attrs[:id]
    task = Repo.get(Task, id)

    task
    |> Task.updatetask_validate(task_attrs)
    |> Repo.update()
  end

  def delete_task(taskID) do
    task = Repo.get!(Task, taskID)
    Repo.delete(task)
  end
end
