defmodule DatabaseUtil.Tools.Task_Tools do
  alias LangChain.Function
  alias DatabaseUtil.TaskFunctions

  def get_all_tasks_tool do
  Function.new!(%{
    name: "get_all_tasks",
    description: "Retrieves all tasks from the database. all tasks have a priority with 1 being the lowest
    and 5 the highest. You can use this to sort by piority when asked. Tasks have a title, content, due date and whether
    or not the task is completed.",
    parameters_schema: nil,
    function: fn _args, _context ->
      tasks = TaskFunctions.get_all_tasks()
      {:ok, tasks}
    end
  })
end

def create_tasks_tool do
  Function.new!(%{
    name: "create_tasks",
    description: "creates a new task in the database. Requires the user ID which is a UUID. Tasks take a title,
    content, priority, due date, and whether its completed. Priority, due date and completed are optional
    when creating a task. priority will default to 3 and completed false.",
    parameters_schema: %{
        type: "object",
        properties: %{
          title: %{type: "string", description: "the title of the task."},
          content: %{type: "string", description: "the body of the task describing what needs to be done."},
          priority: %{type: "number", description: "The priority of the task with 1 being the lowest and 5 highest."},
          completed: %{type: "boolean", description: "true or false deciding if the task is completed. defaults to false."},
          due_date: %{type: "string", description: "the date the task is due."},
          user_id: %{type: "string", description: "the id of of the user which is a UUID. all tasks must belong to a user."}
        },
        required: ["title", "content", "user_id"]
      },
    function: fn task_attrs, _context ->
      case TaskFunctions.create_tasks(task_attrs) do
        {:ok, task} -> {:ok, "Task created successfully with id: #{task.id}"}
        {:error, changeset} -> {:error, inspect(changeset.errors)}
      end
    end
  })
end

end
