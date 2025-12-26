defmodule DatabaseUtil.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias DatabaseUtil.Utilities

  @primary_key {:id, UUIDv7.Type, autogenerate: true}
  @derive {Jason.Encoder, except: [:__meta__, :password_hashed, :encrypted_user_key]}
  schema "users" do
    field(:email_hased, :string)
    field(:email_encrypted, :binary)
    field(:password_hashed, :string)
    field(:encrypted_user_key, :binary)
    field(:timezone, :string)
  end

  def user_validate(user, attrs) do
    user
    |> cast(attrs, [:email, :raw_password])
    |> validate_required([:email, :raw_password])
    |> validate_format(:email, ~r/^[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/,
      message: "must be a valid email"
    )
    |> validate_format(:raw_password, ~r/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$/,
      message: "must contain at least one letter and one number"
    )
    |> unique_constraint(:email)
    |> send_to_hash()
  end

  # validation for updating the email and password is separate
  def email_validate(user, user_attr) do
    user
    |> cast(user_attr, [:email])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/,
      message: "must be a valid email"
    )
    |> unique_constraint(:email)
  end

  def password_validate(user, user_attrs) do
    user
    |> cast(user_attrs, [:raw_password])
    |> validate_required(:raw_password)
    |> validate_format(:raw_password, ~r/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$/,
      message: "must contain at least one letter and one number"
    )
    |> send_to_hash()
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
