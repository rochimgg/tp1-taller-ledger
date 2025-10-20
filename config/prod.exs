# prod env configs
import Config

config :logger, :console,
  format: "\n[$level] $message\n",
  colors: [
    debug: :cyan,
    info: :green,
    warn: :yellow,
    error: :red
  ],
  metadata: [:module, :function, :line],
  truncate: 512,
  level: :info
