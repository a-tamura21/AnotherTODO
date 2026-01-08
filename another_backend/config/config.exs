# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Register the Ecto repo
config :database_util,
  ecto_repos: [DatabaseUtil.Repo]

# Repo-specific settings
# config :database_util, DatabaseUtil.Repo,
# database: "another_todo",
# username: "postgres",
# password: "admin",
# hostname: "localhost",
# pool_size: 10
