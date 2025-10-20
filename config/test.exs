# test env configs
import Config

config :logger, :console,
  format: "[$level] $message\n",
  truncate: 512,
  level: :error
