defmodule Ledger.CLI.UserUpdate do
  alias Ledger.Users.Users, as: UserService

  def run(opts) do
    case update_user(opts, UserService) do
      {:ok, user} ->
        IO.puts("Usuario actualizado exitosamente: #{user.username}")

      {:error, reason} ->
        IO.puts("Error al actualizar usuario: #{inspect(reason)}")
    end
  end

  defp update_user(%{user_id: id, username: username}, users_module) do
    users_module.update_user(id, %{username: username})
  end

end
