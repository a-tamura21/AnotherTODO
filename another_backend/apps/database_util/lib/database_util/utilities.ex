defmodule DatabaseUtil.Utilities do
  def hash_password(password) do
    hashed = Pbkdf2.hash_pwd_salt(password)

    Pbkdf2.verify_pass(password, hashed)
    IO.inspect(hashed)
  end
end
