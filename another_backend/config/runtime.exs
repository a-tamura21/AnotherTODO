import Config
import Dotenvy

# Read the file
source!([".env"])

config :database_util, Database_util.Repo,
  username: env!("USERNAME", :string!),
  password: env!("PASSWORD", :string!),
  database: env!("DATABASE", :string!),
  hostname: env!("HOSTNAME", :string!),
  # Default to 10
  pool_size: env!("POOL", :integer, 10)

config :database_util, :db_encryption, master_key: env!("MASTER_KEY", :string!)
