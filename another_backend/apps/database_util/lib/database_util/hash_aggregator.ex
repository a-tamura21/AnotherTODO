defmodule DatabaseUtil.HashAggregator do
  alias DatabaseUtil.{Repo, Task, Hashed.HMAC}
  import Ecto.Query

  def generate_for_user(user_id) do
    # 1. Fetch only the hashes from the DB (efficient)
    # We SORT by ID to ensure the hash is the same every time
    # regardless of the order the DB returns the rows.
    query =
      from(t in Task,
        where: t.user_id == ^user_id,
        order_by: [asc: :id],
        select: t.content_hashed
      )

    hashes = Repo.all(query)

    # 2. Join the binaries together
    # If the user has no tasks, we use an empty string
    combined_string = Enum.join(hashes, "")

    # 3. Hash the resulting "Mega-string"
    # This becomes the aggregated_hash for the user_summary
    {:ok, final_hash} = HMAC.dump(combined_string)

    final_hash
  end
end
