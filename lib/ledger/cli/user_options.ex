defmodule Ledger.CLI.UserOptions do
  def create_user_options do
    [
      user_name_option(),
      user_birth_date_option()
    ]
    |> Enum.flat_map(& &1)
  end

  def update_user_options do
    [
      user_id_option(),
      user_name_option()
    ]
    |> Enum.flat_map(& &1)
  end

  def delete_user_options do
    [
      user_id_option()
    ]
    |> Enum.flat_map(& &1)
  end

  def get_user_options do
    [
      user_id_option()
    ]
    |> Enum.flat_map(& &1)
  end

  # Opciones individuales (cada una devuelve una Keyword list)
  defp user_name_option do
    [
      user_name: [
        long: "--id",
        value_name: "NOMBRE_USUARIO",
        help: "Nombre del usuario (obligatorio)",
        required: true
      ]
    ]
  end

  defp user_id_option do
    [
      user_id: [
        long: "--u",
        value_name: "ID_USUARIO",
        help: "Id del usuario (obligatorio)",
        required: true
      ]
    ]
  end

  defp user_birth_date_option do
    [
      user_birthdate: [
        long: "--b",
        value_name: "FECHA_NACIMIENTO",
        help: "Fecha de nacimiento del usuario (obligatorio)",
        required: true
      ]
    ]
  end
end
