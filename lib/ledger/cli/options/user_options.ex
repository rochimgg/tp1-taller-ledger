defmodule Ledger.CLI.UserOptions do
  def create_user_options do
    [
      username_option(),
      birthdate_option()
    ]
    |> Enum.flat_map(& &1)
  end

  def update_user_options do
    [
      user_id_option(),
      username_option()
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
  defp username_option do
    [
      username: [
        long: "--n",
        value_name: "NOMBRE_USUARIO",
        help: "Nombre del usuario (obligatorio)",
        required: true
      ]
    ]
  end

  defp user_id_option do
    [
      user_id: [
        long: "--id",
        value_name: "ID_USUARIO",
        help: "Id del usuario (obligatorio)",
        required: true
      ]
    ]
  end

  defp birthdate_option do
    [
      birthdate: [
        long: "--b",
        value_name: "FECHA_NACIMIENTO",
        help: "Fecha de nacimiento del usuario (obligatorio)",
        required: true
      ]
    ]
  end
end
