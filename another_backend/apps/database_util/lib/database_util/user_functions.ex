defmodule DatabaseUtil.UserTasks do
  alias DatabaseUtil.User
  alias DatabaseUtil.Repo

  def get_users do
    Repo.all(User)
  end

  def create_user do
    new_user =
      %{email: "tiuom@gmail.cm", password: "", timezone: "NYC"}

    create_new_user = DatabaseUtil.User.changeset(%User{}, new_user)
    Repo.insert(create_new_user)
  end
end
