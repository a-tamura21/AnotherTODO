defmodule DatabaseUtil.UserTasks do
  alias Hex.API.User
  alias DatabaseUtil.User
  alias DatabaseUtil.Repo

  def get_users do
    Repo.all(User)
  end

  def create_user(user_attr) do
    %User{}
    |> User.user_validate(user_attr)
    |> Repo.insert!()
  end

  def update_email(user_attrs) do
    id = user_attrs[:id]
    updated_email = Repo.get(User, id)

    updated_email
    |> User.email_validate(user_attrs)
    # reminder that the validated email will be passed back.
    |> Repo.update()
  end

  def update_password(user_attrs) do
    id = user_attrs[:id]
    updated_password = Repo.get(User, id)

    updated_password
    |> User.password_validate(user_attrs)
    |> Repo.update()
  end

  def update_timezone(user_attrs) do
    id = user_attrs[:id]
    updated_timezone = Repo.get(User, id)

    updated_timezone
    |> User.timezone_validate(user_attrs)
    |> Repo.update()
  end
end
