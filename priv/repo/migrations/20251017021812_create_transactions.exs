defmodule Ledger.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :origin_currency_id, references(:currencies, on_delete: :nothing), null: false
      add :destination_currency_id, references(:currencies, on_delete: :nothing)
      add :amount, :float, null: false
      add :origin_account_id, references(:users, on_delete: :restrict), null: false
      add :destination_account_id, references(:users, on_delete: :restrict)
      add :type, :string, null: false
      timestamps(updated_at: false)
    end
  end
end
