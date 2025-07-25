defmodule DatabaseUtil.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias DatabaseUtil.Utilities

  @derive {Jason.Encoder, except: [:__meta__, :password]}
  schema "users" do
    field(:email, :string)
    field(:raw_password, :string, virtual: true)
    field(:password, :string)
    field(:timezone, :string)
  end

  def user_validate(user, attrs) do
    user
    |> cast(attrs, [:email, :raw_password])
    |> validate_required([:email, :raw_password])
    |> validate_format(:email, ~r/@/)
    |> validate_format(:raw_password, ~r/^[A-Za-z]+$/, message: "must contain only letters")
    |> unique_constraint(:email)
    |> send_to_hash()
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
    |> validate_format(:name, ~r/^[A-Za-z]+$/, message: "must contain only letters")
  end

  def timezone_validate(user, user_attrs) do
    user
    |> cast(user_attrs, [:timezone])
    |> validate_required(:timezone)
  end

  defp send_to_hash(changeset) do
    if raw = get_change(changeset, :raw_password) do
      put_change(changeset, :password, Utilities.hash_password(raw))
    else
      changeset
    end
  end
end
