defmodule Ledger.Constants do
  def transaction_options do
    ledger_options_tp1()
  end

  def balance_options do
    ledger_options_tp1(%{
      origin_account: [
        long: "--c1",
        value_name: "CUENTA_ORIGEN",
        help:
          "Especifica la cuenta origen (si no se completa, toma todas las cuentas. Es obligatorio para balance)",
        required: true
      ]
    })
  end

  def currency_creation_options do
    %{
      currency_name: [
        long: "--n",
        value_name: "NOMBRE_MONEDA",
        help: "Nombre de la nueva moneda (obligatorio)",
        required: true
      ],
      usd_exchange_rate: [
        long: "--p",
        value_name: "TASA_USD",
        help: "Tasa de cambio respecto al USD (obligatorio)",
        required: true
      ]
    }
    |> Enum.map(fn {key, opts} ->
      {key, Keyword.put_new(opts, :required, false)}
    end)
  end

  defp ledger_options_tp1(overrides \\ %{}) do
    base_options_tp1()
    |> Map.merge(overrides)
    |> Enum.map(fn {key, opts} ->
      {key, Keyword.put_new(opts, :required, false)}
    end)
  end

  defp base_options_tp1 do
    %{
      origin_account: [
        long: "--c1",
        value_name: "CUENTA_ORIGEN",
        help: "Especifica la cuenta origen (si no se completa, toma todas las cuentas)"
      ],
      destination_account: [
        long: "--c2",
        value_name: "CUENTA_DESTINO",
        help: "Especifica la cuenta destino (si no se completa, toma todas las cuentas)"
      ],
      transaction_file_path: [
        long: "--t",
        value_name: "ARCHIVO_CSV",
        default: Path.join(File.cwd!(), "priv/data/transacciones.csv"),
        help: "Archivo transacciones input (si no se completa toma por default transacciones.csv)"
      ],
      currency: [
        long: "--m",
        value_name: "MONEDA",
        help: "Moneda a utilizar para el cálculo de balances."
      ],
      output_file_path: [
        long: "--o",
        value_name: "ARCHIVO_SALIDA",
        help: "Archivo de salida (si no se completa se imprimen por terminal)"
      ]
    }
  end
end
