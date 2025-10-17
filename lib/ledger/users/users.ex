defmodule Ledger.Users.Users do
  alias Ledger.Users.User, as: User
  alias Ledger.Repo, as: Repo

  def create_user(%{username: username, birthdate: birthdate}) do
    %User{}
    |> User.changeset(%{username: username, birthdate: birthdate})
    |> Repo.insert()
  end

  @spec update_user(
          any(),
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: any()
  def update_user(id, attrs) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, attrs)
    Repo.update(changeset)
  end

  @spec delete_user(integer()) :: {:ok, User.t()} | {:error, :not_found}
  def delete_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end
end
