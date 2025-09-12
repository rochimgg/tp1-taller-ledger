defmodule Ledger.CLI.Balance do
  alias Ledger.Services.FileOperations, as: FileOperations

  def run(args) do
    IO.inspect(args, label: "Ejecutando comando balance")
    transacciones = FileOperations.leer_csv(args.flags[:t])
    transacciones
  end
end
