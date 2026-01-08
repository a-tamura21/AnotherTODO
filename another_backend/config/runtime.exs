import Config
import Dotenvy

# 1. Load the .env file once (Standard 2026 practice)
source!([".env", System.get_env()])

# 2. Database Configuration
config :database_util, DatabaseUtil.Repo,
  username: env!("USERNAME", :string!),
  password: env!("PASSWORD", :string!),
  database: env!("DATABASE", :string!),
  hostname: env!("HOSTNAME", :string!),
  pool_size: env!("POOL", :integer, 10)

# 3. Master Key for Vault
# This single key is used by your Vault to derive BOTH
# the encryption key and the blind index search key.
config :database_util, :db_encryption, master_key: env!("MASTER_KEY", :string!)
