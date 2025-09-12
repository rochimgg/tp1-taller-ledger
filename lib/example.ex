alias Ledger.Schemas.Transaccion, as: Transaccion

defmodule Example do

  def transacciones(args) do
    c1 = args.flags[:c1] || 0
    IO.puts("Transacciones")
    IO.puts("args; #{inspect(c1)}")
    x = %Transaccion{id_transaccion: 1, timestamp: "2023-10-10T10:00:00Z", moneda_origen: "USD", monto: 100.0, cuenta_origen: "A", tipo: "transferencia"}
    to_string(x)
    # Aquí iría la lógica para manejar la autenticación
  end

  def balance(args) do
    c1 = args.flags[:c1] || 0
    c2 = args.args[:c2] || 1
    IO.puts("Balance")
    IO.puts("Cuenta origen: #{c1}")
    IO.puts("Cuenta destino: #{c2}")
    # Aquí iría la lógica para listar las intenciones
  end
end
