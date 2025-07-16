defmodule DatabaseUtil.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :password]}
  schema "users" do
    field(:email, :string)
    field(:password, :string)
    field(:timezone, :string)
  end

  def user_validate(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  # validation for updating the email and password is separate
  def email_validate(user, user_attr) do
    user
    |> cast(user_attr, [:email])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def password_validate(user, user_attrs) do
    user
    |> cast(user_attrs, [:password])
    |> validate_required(:password)
  end

  def timezone_validate(user, user_attrs) do
    user
    |> cast(user_attrs, [:timezone])
    |> validate_required(:timezone)
  end
end
