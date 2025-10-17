
defmodule Ledger.CLI.UserSubcommands do

  alias Ledger.CLI.UserOptions, as: UserOptions

  def get_all do
    [
      create_user(),
      update_user(),
      delete_user(),
      get_user()
    ]
    |> Enum.flat_map(&Map.to_list/1)

  end

  defp create_user do
    %{
      crear_usuario: [
        name: "crear_usuario",
        about: "Crear un nuevo usuario",
        options: UserOptions.create_user_options()
      ]
    }
  end

  defp update_user do
    %{
      editar_usuario: [
        name: "editar_usuario",
        about: "Editar un usuario existente",
        options: UserOptions.update_user_options()
      ]
    }
  end

  defp delete_user do
    %{
      eliminar_usuario: [
        name: "eliminar_usuario",
        about: "Eliminar un usuario existente",
        options: UserOptions.delete_user_options()
      ]
    }
  end

  defp get_user do
    %{
      obtener_usuario: [
        name: "obtener_usuario",
        about: "Obtener un usuario existente",
        options: UserOptions.get_user_options()
      ]
    }
  end
end
