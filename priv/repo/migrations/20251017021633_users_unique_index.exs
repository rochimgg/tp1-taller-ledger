defmodule Ledger.Repo.Migrations.UsersUniqueIndex do
  use Ecto.Migration

  def change do
    drop_if_exists index(:users, [:user_name])
    create unique_index(:users, [:user_name], name: :unique_user_name_index)
  end
end
