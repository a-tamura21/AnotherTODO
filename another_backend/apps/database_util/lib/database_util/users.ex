defmodule DatabaseUtil.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :password]}
  schema "users" do
    field(:email, :string)
    field(:password, :string)
    field(:timezone, :string)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
