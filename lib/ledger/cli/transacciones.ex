alias Ledger.Schemas.Transaccion, as: Transaccion

defmodule Ledger.CLI.Transacciones do
  def run(args) do
    IO.inspect(args, label: "Ejecutando comando transacciones")
        transaccion = %Transaccion{id_transaccion: 1, timestamp: "2023-10-10T10:00:00Z", moneda_origen: "USD", monto: 100.0, cuenta_origen: "A", tipo: "transferencia"}
        transaccion
  end
end
