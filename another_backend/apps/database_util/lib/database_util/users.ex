defmodule DatabaseUtil.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias DatabaseUtil.{Utilities}

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Inspect, except: [:email_encrypted]}

  schema "users" do
    # These match your MIGRATION columns
    field(:email_hashed, DatabaseUtil.Hashed.HMAC)
    field(:email_encrypted, DatabaseUtil.Encrypted.Binary)
    # Matches password_hahsed in your migration
    field(:password_hashed, :string)
    field(:timezone, :string)

    # VIRTUAL fields for raw user input (not saved to DB directly)
    field(:email, :string, virtual: true)
    field(:password, :string, virtual: true)

    timestamps(type: :utc_datetime)
  end

  # Main registration validation
  def user_validate(user, attrs) do
    user
    # Added timezone if needed
    |> cast(attrs, [:email, :password, :timezone])
    |> validate_required([:email, :password])
    |> common_validations()
    # This now handles email AND password
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
    |> validate_format(:password, ~r/^(?=.*[A-Za-z])(?=.*\d).+$/)
  end

  # The Security Pipeline
  defp prepare_sensitive_data(changeset) do
    # Handle Email
    changeset =
      if email = get_change(changeset, :email) do
        # MANUALLY HASH IT HERE
        # Since your HMAC.dump test works, use it directly:
        case DatabaseUtil.Hashed.HMAC.dump(email) do
          {:ok, hashed_email} ->
            changeset = put_change(changeset, :email_hashed, hashed_email)

            # Continue with encryption
            case DatabaseUtil.Vault.encrypt(email) do
              {:ok, encrypted_binary} -> put_change(changeset, :email_encrypted, encrypted_binary)
              {:error, _} -> add_error(changeset, :email, "encryption failed")
            end

          _ ->
            add_error(changeset, :email, "hashing failed")
        end
      else
        changeset
      end

    # Handle Password
    if password = get_change(changeset, :password) do
      put_change(changeset, :password_hashed, DatabaseUtil.Utilities.hash_password(password))
    else
      changeset
    end
  end
end
