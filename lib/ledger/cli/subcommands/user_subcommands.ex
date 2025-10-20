defmodule Ledger.CLI.Subcommands.UserSubcommands do
  alias Ledger.CLI.Options.UserOptions

  def get_all(options_module \\ UserOptions) do
    [
      create_user(options_module),
      update_user(options_module),
      delete_user(options_module),
      get_user(options_module)
    ]
    |> Enum.flat_map(&Map.to_list/1)
  end

  defp create_user(options_module) do
    %{
      crear_usuario: [
        name: "crear_usuario",
        about: "Crear un nuevo usuario",
        options: options_module.create_user_options()
      ]
    }
  end

  defp update_user(options_module) do
    %{
      editar_usuario: [
        name: "editar_usuario",
        about: "Editar un usuario existente",
        options: options_module.update_user_options()
      ]
    }
  end

  defp delete_user(options_module) do
    %{
      eliminar_usuario: [
        name: "eliminar_usuario",
        about: "Eliminar un usuario existente",
        options: options_module.delete_user_options()
      ]
    }
  end

  defp get_user(options_module) do
    %{
      ver_usuario: [
        name: "ver_usuario",
        about: "Obtener un usuario existente",
        options: options_module.get_user_options()
      ]
    }
  end
end
