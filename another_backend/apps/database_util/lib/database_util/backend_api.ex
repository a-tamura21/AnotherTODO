defmodule DatabaseUtil.BackendApi do
  alias DatabaseUtil.TaskFunctions
  alias DatabaseUtil.UserTasks
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json, :urlencoded],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome to AnotherToDo")
  end

  get "/tasks" do
    tasks = TaskFunctions.get_all_tasks()
    send_resp(conn, 200, tasks)
  end

  post "tasks" do
    data = conn.body_params
    IO.inspect(data)
    TaskFunctions.create_tasks(data)
    send_resp(conn, 200, "received")
  end

  post "users" do
    user = conn.body_params
    IO.inspect(user)
    UserTasks.create_user(user)
    send_resp(conn, 200, "OK")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
