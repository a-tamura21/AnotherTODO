defmodule DatabaseUtil.Tools.Task_Tools do
  alias LangChain.Function
  alias DatabaseUtil.TaskFunctions

  def get_all_tasks_tool do
  Function.new!(%{
    name: "get_all_tasks",
    description: "Retrieves all tasks from the database",
    parameters_schema: nil,
    function: fn _args, _context ->
      tasks = TaskFunctions.get_all_tasks()  # hardcode for now
      {:ok, tasks}
    end
  })
end

end
