defmodule DatabaseUtil.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias DatabaseUtil.{Encrypted, Vault, Utilities}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    # These match your MIGRATION columns
    field(:email_hashed, Cloak.Ecto.HMAC, vault: Vault, secret_key: &Vault.search_key/0)
    field(:email_encrypted, Encrypted.Binary)
    # Matches password_hahsed in your migration
    field(:password_hashed, :string)
    field(:encrypted_user_key, Encrypted.Binary)
    field(:timezone, :string)

    # VIRTUAL fields for raw user input (not saved to DB directly)
    field(:email, :string, virtual: true)
    field(:password, :string, virtual: true)

    timestamps(type: :utc_datetime)
  end

  # Main registration validation
  def user_validate(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :timezone])
    |> validate_required([:email, :password, :timezone])
    |> common_validations()
    |> prepare_sensitive_data()
    # Constraint is on the HASH
    |> unique_constraint(:email_hashed)
  end

  def email_validate(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/)
    # HMAC type hashes this
    |> put_change(:email_hashed, get_change(user, :email))
    # Encrypted type encrypts this
    |> put_change(:email_encrypted, get_change(user, :email))
    |> unique_constraint(:email_hashed)
  end

  def password_validate(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_format(:password, ~r/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$/)
    |> put_change(:password_hashed, Utilities.hash_password(get_change(user, :password)))
  end

  # Helper for shared regex logic
  defp common_validations(changeset) do
    changeset
    |> validate_format(:email, ~r/^[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/)
    |> validate_format(:password, ~r/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]+$/)
  end

  # The Security Pipeline
  defp prepare_sensitive_data(changeset) do
    if changeset.valid? do
      email = get_change(changeset, :email)
      password = get_change(changeset, :password)

      changeset
      # Cloak.Ecto.HMAC handles hashing automatically if we pass plain text
      |> put_change(:email_hashed, email)
      # Encrypted.Binary handles encryption automatically via Vault
      |> put_change(:email_encrypted, email)
      # Argon2/Bcrypt for password
      |> put_change(:password_hashed, Utilities.hash_password(password))
      # Generate a unique key for this specific user
      |> put_change(:encrypted_user_key, :crypto.strong_rand_bytes(32))
    else
      changeset
    end
  end
end
