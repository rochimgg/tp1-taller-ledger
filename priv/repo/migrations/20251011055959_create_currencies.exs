defmodule Ledger.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :currency_name, :string, null: false
      add :usd_exchange_rate, :float, null: false
      timestamps()
    end
  end
end
