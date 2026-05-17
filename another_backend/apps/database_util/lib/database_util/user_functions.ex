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
    email = user_attrs[:email]

    email
    |> User.common_validations()

    id = user_attrs[:id]

    hashed_email = Repo.get!(User, id).email_hashed
    IO.inspect(hashed_email)

    IO.inspect(email)

    # updated_email
    # |> User.email_validate(user_attrs)
    # # reminder that the validated email will be passed back.
    # |> Repo.update()
  end

  def update_password(user_attrs) do
    id = user_attrs[:id]
    user = Repo.get(User, id)

    user
    |> User.password_validate(user_attrs)
    |> Repo.update()
  end

  # def update_timezone(user_attrs) do
  #   id = user_attrs[:id]
  #   updated_timezone = Repo.get(User, id)

  #   updated_timezone
  #   |> User.timezone_validate(user_attrs)
  #   |> Repo.update()
  # end
end
