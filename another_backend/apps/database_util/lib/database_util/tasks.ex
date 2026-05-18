defmodule DatabaseUtil.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, UUIDv7.Type, autogenerate: true}
  @foreign_key_type UUIDv7.Type
  @derive {Jason.Encoder,
           only: [
             :id,
             :content_encrypted,
             :is_complete,
             :due_date,
             :priority,
             :user_id,
             :inserted_at,
             :updated_at
           ]}
  @derive {Inspect, except: [:content_encrypted]}
  schema "tasks" do
    field(:title_encrypted, DatabaseUtil.Encrypted.Binary)
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
    changeset
    |> encrypt_title()
    |> secure_content()
  end

  # 1. Handle Title Encryption
  defp encrypt_title(changeset) do
    with title when not is_nil(title) <- get_change(changeset, :title),
         {:ok, encrypted_title} <- DatabaseUtil.Vault.encrypt(title) do
      put_change(changeset, :title_encrypted, encrypted_title)
    else
      nil -> changeset
      _error -> add_error(changeset, :title, "encryption failed")
    end
  end

  # 2. Handle Content (Hashing and Encryption)
  defp secure_content(changeset) do
    with content when not is_nil(content) <- get_change(changeset, :content),
         {:ok, hashed} <- DatabaseUtil.Hashed.HMAC.dump(content),
         {:ok, encrypted} <- DatabaseUtil.Vault.encrypt(content) do
      changeset
      |> put_change(:content_hashed, hashed)
      |> put_change(:content_encrypted, encrypted)
    else
      nil ->
        changeset

      # If content hashing succeeds but encryption fails, this catch-all or a specific match handles it
      _error ->
        # Note: If your app needs to differentiate why it failed, you can match specific error tuples here
        add_error(changeset, :content, "security processing failed")
    end
  end
end
