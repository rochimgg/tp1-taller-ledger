defmodule Ledger.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :timestamp, :time_usec, null: false
      add :origin_currency_id, references(:currencies, on_delete: :nothing), null: false
      add :destination_currency_id, references(:currencies, on_delete: :nothing), null: false
      add :amount, :float, null: false
      add :origin_account_id, references(:users, on_delete: :restrict), null: false
      add :destination_account_id, references(:users, on_delete: :restrict), null: false
      add :type, :string, null: false
      timestamps()
    end
  end
end
