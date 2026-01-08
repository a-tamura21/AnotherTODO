import Config
import Dotenvy

# 1. Load the .env file once
source!([".env", System.get_env()])

# 2. Database Configuration
config :database_util, DatabaseUtil.Repo,
  username: env!("USERNAME", :string!),
  password: env!("PASSWORD", :string!),
  database: env!("DATABASE", :string!),
  hostname: env!("HOSTNAME", :string!),
  pool_size: env!("POOL", :integer, 10)

# 3. Encryption & Search Configuration
# This is what your Vault uses to derive the keys
config :database_util, :db_encryption, master_key: env!("MASTER_KEY", :string!)
