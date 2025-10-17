defmodule Ledger.Repo.Migrations.TransactionsUniqueIndex do
  use Ecto.Migration

  def change do
    drop_if_exists index(:transactions, [:origin_currency])
    create unique_index(:transactions, [:origin_currency], name: :unique_origin_currency_index)
    drop_if_exists index(:transactions, [:destination_currency])
    create unique_index(:transactions, [:destination_currency], name: :unique_destination_currency_index)
    drop_if_exists index(:transactions, [:origin_account])
    create unique_index(:transactions, [:origin_account], name: :unique_origin_account_index)
    drop_if_exists index(:transactions, [:destination_account])
    create unique_index(:transactions, [:destination_account], name: :unique_destination_account_index)
  end
end
