require Logger

defmodule Ledger.CLI.UserDelete do
  alias Ledger.Users.Users, as: UserService

  @spec run(any(), any()) :: {:ok, any()} | {:error, any()}
  def run(args, user_service \\ UserService) do
    case parse_args(args) do
      {:ok, opts} ->
        Logger.info("Ejecutando comando eliminar usuario con opciones: #{inspect(opts)}")
        delete_user(opts, user_service)

      {:error, reason} ->
        Logger.error("Error en los argumentos: #{reason}")
        {:error, :invalid_args, reason}
    end
  end

  # ✅ Caso 1: si los args vienen en formato de lista (por ejemplo ["-i", "1"])
  defp parse_args(args) when is_list(args) do
    {opts, _rest, _invalid} =
      OptionParser.parse(args,
        switches: [id: :integer],
        aliases: [i: :id]
      )

    validate_opts(opts)
  end

  # ✅ Caso 2: si los args ya vienen como un mapa (por ejemplo %{user_id: "1"})
  defp parse_args(%{user_id: id}) when is_binary(id) do
    case Integer.parse(id) do
      {int_id, _} -> {:ok, %{id: int_id}}
      :error -> {:error, "El ID del usuario debe ser un número entero"}
    end
  end

  defp parse_args(%{id: id}) when is_integer(id), do: {:ok, %{id: id}}
  defp parse_args(_), do: {:error, "Debe especificar el ID del usuario con -i o --id o user_id"}

  # Helper
  defp validate_opts(%{id: nil}), do: {:error, "Debe especificar el ID del usuario con -i o --id"}
  defp validate_opts(%{id: _id} = opts), do: {:ok, opts}
  defp validate_opts(_), do: {:error, "Argumentos inválidos"}

  # 🚀 Eliminar usuario
  defp delete_user(%{id: id}, user_service) do
    case user_service.delete_user(id) do
      {:ok, user} ->
        Logger.info("Usuario eliminado exitosamente: #{inspect(user)}")
        {:ok, user}

      {:error, :not_found} ->
        Logger.error("No se encontró el usuario con ID #{id}")
        {:error, :not_found, "No se encontró el usuario con ID #{id}"}

      {:error, reason} ->
        Logger.error("Error al eliminar el usuario: #{inspect(reason)}")
        {:error, reason}
    end
  end
end
