defmodule Ledger.Constants do

  def transaction_options do
    ledger_options()
  end

  def balance_options do
    ledger_options(%{
      origin_account: [
        long: "--c1",
        value_name: "CUENTA_ORIGEN",
        help: "Especifica la cuenta origen (obligatorio para balance)",
        required: true
      ]
    })
  end

  defp ledger_options(overrides \\ %{}) do
    base_options()
    |> Map.merge(overrides)
    |> Enum.map(fn {key, opts} ->
      {key, Keyword.put_new(opts, :required, false)}
    end)
  end

  # Definición base de opciones compartidas
  defp base_options do
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
        default: Path.join(:code.priv_dir(:ledger), "data/transacciones.csv"),
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
