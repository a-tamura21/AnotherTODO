defmodule DatabaseUtil.UserSummary do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_summaries" do
    field(:model_used, :string)
    field(:aggregated_hash, DatabaseUtil.Hashed.HMAC)
    field(:summary_encrypted, DatabaseUtil.Encrypted.Binary)

    belongs_to(:user, DatabaseUtil.User)

    timestamps(type: :utc_datetime)
  end

  @supported_models ["gpt-4o", "claude-3.5-sonnet", "o1-preview"]

  def changeset(user_summary, attrs) do
    user_summary
    |> cast(attrs, [:user_id, :model_used, :summary_encrypted])
    |> validate_required([:user_id, :model_used, :summary_encrypted])
    |> validate_inclusion(:model_used, @supported_models)
    # This is where the schema "calls" the aggregator
    |> prepare_aggregated_hash()
    |> unique_constraint(:user_id)
  end

  defp prepare_aggregated_hash(changeset) do
    # Get the user_id from the changeset (either from the struct or the casted params)
    user_id = get_field(changeset, :user_id)

    if user_id do
      # CALL THE AGGREGATOR MODULE
      # Note: This assumes HashAggregator.generate_for_user exists as we discussed
      new_hash = DatabaseUtil.HashAggregator.generate_for_user(user_id)

      put_change(changeset, :aggregated_hash, new_hash)
    else
      changeset
    end
  end
end
