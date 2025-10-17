defmodule Ledger.Repo.Migrations.UsersUniqueIndex do
  use Ecto.Migration

  def change do
    drop_if_exists index(:users, [:username])
    create unique_index(:users, [:username], name: :unique_username_index)
  end
end
