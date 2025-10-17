require Logger

defmodule Ledger.CLI.UserGet do
  alias Ledger.Users.Users, as: UserService

  @spec run(%{:user_id => nil | binary() | integer(), optional(any()) => any()}) ::
          {:ok, any()}
          | {:error, :invalid_id_format | :missing_id | :not_found, <<_::64, _::_*8>>}
  def run(opts, user_service \\ UserService) do
    Logger.info("Ejecutando comando obtener usuario con opciones: #{inspect(opts)}")
    get_user(opts, user_service)
  end

  defp get_user(%{user_id: nil}, _user_service) do
    {:error, :missing_id, "Debe especificarse un ID de usuario."}
  end

  defp get_user(%{user_id: id_str}, user_service) when is_binary(id_str) do
    case Integer.parse(id_str) do
      {id, _} -> get_user(%{user_id: id}, user_service)
      :error -> {:error, :invalid_id_format, "El ID debe ser un número entero."}
    end
  end

  defp get_user(%{user_id: id}, user_service) when is_integer(id) do
    case user_service.get_user(id) do
      {:ok, user} ->
        Logger.info("Usuario encontrado: #{inspect(user)}")
        {:ok, user}

      {:error, :not_found} ->
        Logger.error("No se encontró un usuario con ID #{id}")
        {:error, :not_found, "No se encontró un usuario con ID #{id}"}
    end
  end
end
