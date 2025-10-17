defmodule Ledger.Users.Users do
  alias Ledger.Users.User
  alias Ledger.Repo

  def create_user(%{username: username, birthdate: birthdate}) do
    %User{}
    |> User.changeset(%{username: username, birthdate: birthdate})
    |> Repo.insert()
  end
end
