require Logger

defmodule Ledger.CLI.UserCreate do
  alias Ledger.Users.Users, as: UserService
  @spec run(any(), any()) :: {:ok, any()} | {:error, any()}
  def run(opts, user_service \\ UserService) do
    Logger.info("Ejecutando comando crear usuario con opciones: #{inspect(opts)}")
    create_user(opts, user_service)
  end

  defp create_user(%{username: nil}, _user_service) do
    {:error, :missing_username, "El nombre de usuario es obligatorio."}
  end

  defp create_user(%{birthdate: nil}, _user_service) do
    {:error, :missing_birthdate, "La fecha de nacimiento es obligatoria."}
  end

  defp create_user(%{birthdate: birthdate_str} = opts, user_service)
       when is_binary(birthdate_str) do
    case Date.from_iso8601(birthdate_str) do
      {:ok, date} ->
        create_user(%{opts | birthdate: date}, user_service)

      {:error, _} ->
        Logger.error("Formato de fecha inválido: #{birthdate_str}")
        {:error, :invalid_birthdate_format, "Formato de fecha inválido. Use YYYY-MM-DD."}
    end
  end

  defp create_user(%{birthdate: birthdate} = opts, user_service)
       when is_struct(birthdate, Date) do
    case Date.diff(Date.utc_today(), birthdate) do
      days when days < 365 * 18 ->
        Logger.error("Error: El usuario debe tener al menos 18 años.")
        {:error, :underage_user, "El usuario debe tener al menos 18 años."}

      _ ->
        case user_service.create_user(%{username: opts.username, birthdate: birthdate}) do
          {:ok, user} ->
            Logger.info("Usuario creado exitosamente: #{inspect(user)}")
            {:ok, user}

          {:error, changeset} ->
            Enum.each(changeset.errors, fn {field, {message, _}} ->
              Logger.error("Error al crear el usuario - #{field}: #{message}")
            end)

            {:error, :changeset_invalid, "No se pudo crear el usuario."}
        end
    end
  end

  defp create_user(%{username: username, birthdate: birthdate}, user_service) do
    case Date.from_iso8601(birthdate) do
      {:ok, date} ->
        user_service.create_user(%{username: username, birthdate: date})
        |> handle_insert_result()

      {:error, _} ->
        {:error, "Fecha de nacimiento inválida. Usá formato YYYY-MM-DD."}
    end
  end

  defp handle_insert_result({:ok, user}), do: {:ok, user}

  defp handle_insert_result({:error, changeset}) do
    {:error, Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)}
  end
end
