import Config

config :ledger,
  ecto_repos: [Ledger.Repo]

config :logger, :console,
  format: "[$level] $message\n",
  truncate: 512,
  level: :debug

import_config "#{config_env()}.exs"
