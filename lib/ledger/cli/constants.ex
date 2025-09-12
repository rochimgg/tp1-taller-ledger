defmodule Ledger.Constants do
  def transaction_options do
    ledger_options()
  end

  def balance_options do
    ledger_options(%{
      c1: [
        long: "--c1",
        value_name: "CUENTA_ORIGEN",
        help: "Especifica la cuenta origen (si no se completa, toma todas las cuentas)",
        required: true
      ]
    })
  end

  defp ledger_options(overrides \\ %{}) do
    base_options()
    |> Map.merge(overrides)
    |> Enum.map(fn {key, opts} -> {key, Keyword.put_new(opts, :required, false)} end)
  end

  defp base_options do
    %{
      c1: [
        long: "--c1",
        value_name: "CUENTA_ORIGEN",
        help: "Especifica la cuenta origen (si no se completa, toma todas las cuentas)"
      ],
      c2: [
        long: "--c2",
        value_name: "CUENTA_DESTINO",
        help: "Especifica la cuenta destino (si no se completa, toma todas las cuentas)"
      ],
      t: [
        long: "--t",
        value_name: "ARCHIVO_CSV",
        default: "transacciones.csv",
        help: "Archivo transacciones input (si no se completa toma por default transacciones.csv)"
      ],
      m: [
        long: "--m",
        value_name: "MONEDA",
        help: "Moneda a utilizar para el cálculo de balances."
      ],
      o: [
        long: "--o",
        value_name: "ARCHIVO_SALIDA",
        help: "Archivo de salida (si no se completa se imprimen por terminal)"
      ]
    }
  end
end
