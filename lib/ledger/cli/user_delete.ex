defmodule Ledger.CLI.UserDelete do
  alias Ledger.Users.Users, as: UserService

  def run(%{user_id: id}) do
    case delete_user(id, UserService) do
      {:ok, user} ->
        IO.puts("Usuario eliminado exitosamente: #{user.username}")

      {:error, :not_found} ->
        IO.puts("Error: No se encontró el usuario con ID #{id}")
    end
  end

  defp delete_user(id, users_module), do: users_module.delete_user(id)
end
