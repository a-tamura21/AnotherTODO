defmodule DatabaseUtil.Encrypted.Binary do
  use Cloak.Ecto.Binary, vault: DatabaseUtil.Vault
end
