import Config

config :ledger,
  ecto_repos: [Ledger.Repo]

config :logger,
  level: :info

import_config "#{config_env()}.exs"
