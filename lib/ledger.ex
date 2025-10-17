defmodule Ledger do
  @commands %{
    balance: Ledger.CLI.Balance,
    transacciones: Ledger.CLI.Transactions,
    crear_moneda: Ledger.CLI.CurrencyCreate,
    crear_usuario: Ledger.CLI.UserCreate,
    editar_usuario: Ledger.CLI.UserUpdate,
    eliminar_usuario: Ledger.CLI.UserDelete,
    ver_usuario: Ledger.CLI.UserGet,
  }

  def main(argv \\ System.argv()) do
    argv
    |> Ledger.CLI.parse_args()
    |> select_subcommand()
  end

  defp select_subcommand({[cmd], args}) do
    case Map.fetch(@commands, cmd) do
      {:ok, module} ->
        module.run(args.options)

      :error ->
        IO.puts("Comando desconocido: #{cmd}")
    end
  end

  defp select_subcommand(_), do: IO.puts("Comando no reconocido o incompleto")
end
