import Config

config :ledger, Ledger.Repo,
  database: System.get_env("POSTGRES_DB"),
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: System.get_env("DB_HOST"),
  port: String.to_integer(System.get_env("DB_PORT")),
  pool_size: System.get_env("POOL_SIZE")
