defmodule Ledger.CLI.Options.TransactionOptions do

  def create_account_options do
    [
      user_id_option(),
      currency_id_option(),
      amount_option()
    ]
    |> Enum.flat_map(& &1)
  end

  def do_transfer_options do
    [
      origin_user_id_option(),
      destination_user_id_option(),
      currency_id_option(),
      amount_option()
    ]
    |> Enum.flat_map(& &1)
  end

  def do_swap_options do
    [
      user_id_option(),
      origin_currency_id_option(),
      destination_currency_id_option(),
      amount_option()
    ]
    |> Enum.flat_map(& &1)
  end

  def undo_transaction_options do
    [
      transaction_id_option()
    ]
    |> Enum.flat_map(& &1)
  end

  def get_transaction_options do
    [
      transaction_id_option()
    ]
    |> Enum.flat_map(& &1)
  end

  defp user_id_option do
    %{
      user_id: [
        long: "--u",
        value_name: "ID_USUARIO",
        help: "Especifica el id del usuario de origen"
      ]
    }
  end

  defp currency_id_option do
    %{
      currency_id: [
        long: "--m",
        value_name: "ID_MONEDA",
        help: "Especifica el id del usuario de origen"
      ]
    }
  end

  defp amount_option do
    %{
      amount: [
        long: "--a",
        value_name: "MONTO",
        help: "Monto de la transacción (obligatorio)",
        required: true
      ]
    }
  end

  defp origin_user_id_option do
    %{
      origin_user_id: [
        long: "--o",
        value_name: "ID_USUARIO_ORIGEN",
        help: "Especifica el id del usuario de origen"
      ]
    }
  end

  defp destination_user_id_option do
    %{
      destination_user_id: [
        long: "--d",
        value_name: "ID_USUARIO_DESTINO",
        help: "Especifica el id del usuario de destino"
      ]
    }
  end

  defp origin_currency_id_option do
    %{
      origin_currency_id: [
        long: "--mo",
        value_name: "ID_MONEDA_ORIGEN",
        help: "Especifica la moneda de origen"
      ]
    }
  end

  defp destination_currency_id_option do
    %{
      destination_currency_id: [
        long: "--md",
        value_name: "ID_MONEDA_DESTINO",
        help: "Especifica la moneda de destino"
      ]
    }
  end

  defp transaction_id_option do
    %{
      transaction_id: [
        long: "--id",
        value_name: "ID_TRANSACCION",
        help: "Id de la transacción (obligatorio)",
        required: true
      ]
    }
  end
end
