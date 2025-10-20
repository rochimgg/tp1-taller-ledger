import Config
import Dotenvy

env = config_env()

# Cargar .env + .env.test si existen
for file <- [".env", ".env.#{env}"], File.exists?(file) do
  {:ok, vars} = Dotenvy.source(file)
  Enum.each(vars, fn {k, v} -> System.put_env(k, v) end)
end


# luego seguir usando env!/2 etc para configurar
config :ledger, Ledger.Repo,
  username: Dotenvy.env!("POSTGRES_USER", :string),
  password: Dotenvy.env!("POSTGRES_PASSWORD", :string),
  hostname: Dotenvy.env!("DB_HOST", :string),
  database: Dotenvy.env!("POSTGRES_DB", :string, "ledger"),
  port: Dotenvy.env!("DB_PORT", :integer, 5432),
  pool_size: Dotenvy.env!("POOL_SIZE", :integer, 10)
