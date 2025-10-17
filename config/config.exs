import Config

config :ledger,
  ecto_repos: [Ledger.Repo]

config :ledger, Ledger.Repo,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: System.get_env("POSTGRES_DB") || "ledger_db",
  hostname: System.get_env("DB_HOST") || "db",
  port: 5432,
  pool_size: 10

config :logger,
  level: :info

import_config "#{config_env()}.exs"
