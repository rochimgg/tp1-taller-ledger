defmodule Ledger.CLI.CurrencyOptions do

  def create_currency_options do
    [
      currency_name_option(),
      usd_exchange_rate_option(),
    ]
    |> Enum.flat_map(& &1)
  end

  def update_currency_options do
    [
      currency_id_option(),
      usd_exchange_rate_option(),
    ]
    |> Enum.flat_map(& &1)
  end

  def delete_currency_options do
    [
      currency_id_option(),
    ]
    |> Enum.flat_map(& &1)
  end

  def get_currency_options do
    [
      currency_id_option(),
    ]
    |> Enum.flat_map(& &1)
  end

  defp currency_id_option do
    %{
      currency_id: [
        long: "--id",
        value_name: "ID_MONEDA",
        help: "Id de la moneda (obligatorio)",
        required: true
      ]
    }
  end

  defp currency_name_option do
    %{
      currency_name: [
        long: "--n",
        value_name: "NOMBRE_MONEDA",
        help: "Nombre de la moneda (obligatorio)",
        required: true
      ]
    }
  end

  defp usd_exchange_rate_option do
    %{
      usd_exchange_rate: [
        long: "--p",
        value_name: "TASA_USD",
        help: "Tasa de cambio respecto al USD (obligatorio)",
        required: true
      ]
    }
  end
end
