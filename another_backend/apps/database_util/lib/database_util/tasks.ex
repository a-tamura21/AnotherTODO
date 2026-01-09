defmodule DatabaseUtil.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, UUIDv7.Type, autogenerate: true}
  @foreign_key_type UUIDv7.Type
  @derive {Jason.Encoder, except: [:__meta__]}
  @derive {Inspect, except: [:content_encrypted]}
  schema "tasks" do
    field(:title_hashed, :string)
    field(:content_encrypted, DatabaseUtil.Encrypted.Binary)
    field(:content_hashed, DatabaseUtil.Hashed.HMAC)
    field(:is_complete, :boolean, default: false)
    field(:due_date, :utc_datetime)
    field(:priority, :integer, default: 3)
    field(:title, :string, virtual: true)
    field(:content, :string, virtual: true)

    belongs_to(:user, DatabaseUtil.User)

    timestamps(type: :utc_datetime)
  end

  def task_validate(task, attrs) do
    task
    |> cast(attrs, [:title, :content, :is_complete, :due_date, :priority, :user_id])
    |> validate_required([:title, :content])
    |> validate_inclusion(:priority, 1..5)
    |> prepare_sensitive_content()
  end

  def updatetask_validate(task, task_attrs) do
    task
    # reminder there's no need to cast the id since this is handle by the DB, casting it may cause issues
    |> cast(task_attrs, [:title, :description, :is_complete, :due_date, :priority, :user_id])
    |> validate_inclusion(:priority, 1..5)
  end

  defp prepare_sensitive_content(changeset) do
    # 1. Handle Title Hashing
    changeset =
      if title = get_change(changeset, :title) do
        case DatabaseUtil.Hashed.HMAC.dump(title) do
          {:ok, hashed_title} ->
            put_change(changeset, :title_hashed, hashed_title)

          _ ->
            add_error(changeset, :title, "hashing failed")
        end
      else
        changeset
      end

    # 2. Handle Content (Hashing and Encryption)
    changeset =
      if content = get_change(changeset, :content) do
        case DatabaseUtil.Hashed.HMAC.dump(content) do
          {:ok, hashed_content} ->
            changeset = put_change(changeset, :content_hashed, hashed_content)

            case DatabaseUtil.Vault.encrypt(content) do
              {:ok, encrypted_binary} ->
                put_change(changeset, :content_encrypted, encrypted_binary)

              {:error, _} ->
                add_error(changeset, :content, "encryption failed")
            end

          _ ->
            add_error(changeset, :content, "hashing failed")
        end
      else
        changeset
      end

    # Final return of the transformed changeset
    changeset
  end
end
