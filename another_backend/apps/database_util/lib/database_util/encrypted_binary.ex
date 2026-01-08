# lib/database_util/encrypted/binary.ex
defmodule DatabaseUtil.Encrypted.Binary do
  use Cloak.Ecto.Binary, vault: DatabaseUtil.Vault
end
