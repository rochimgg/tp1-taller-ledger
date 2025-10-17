defmodule Ledger.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :user_name, :string, null: false
      add :birth_day_date, :date, null: false
      timestamps()
    end
  end
end
