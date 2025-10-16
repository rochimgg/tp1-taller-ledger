defmodule Ledger.Repo.Migrations.CurrencyUniqueIndex do
  use Ecto.Migration

  def change do
    drop_if_exists index(:currencies, [:currency_name])
    create unique_index(:currencies, [:currency_name], name: :unique_currency_name)
  end
end
