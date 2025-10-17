defmodule Ledger.Repo.Migrations.TransactionsUniqueIndex do
  use Ecto.Migration

  def change do
    drop_if_exists index(:transactions, [:origin_currency_id], name: :unique_origin_currency_index)
    drop_if_exists index(:transactions, [:destination_currency_id], name: :unique_destination_currency_index)
    drop_if_exists index(:transactions, [:origin_account_id], name: :unique_origin_account_index)
    drop_if_exists index(:transactions, [:destination_account_id], name: :unique_destination_account_index)

    create index(:transactions, [:origin_currency_id])
    create index(:transactions, [:destination_currency_id])
    create index(:transactions, [:origin_account_id])
    create index(:transactions, [:destination_account_id])

    create unique_index(:transactions, [:origin_account_id],
      name: :unique_alta_cuenta_per_user_index,
      where: "type = 'alta_cuenta'"
    )
  end
end
