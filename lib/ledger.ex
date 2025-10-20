require Logger
defmodule Ledger do
  @commands %{
    balance: Ledger.CLI.Balance,
    transacciones: Ledger.CLI.Transactions,
    crear_usuario: Ledger.CLI.Users.UserCreate,
    editar_usuario: Ledger.CLI.Users.UserUpdate,
    borrar_usuario: Ledger.CLI.Users.UserDelete,
    ver_usuario: Ledger.CLI.Users.UserGet,
    crear_moneda: Ledger.CLI.Currencies.CurrencyCreate,
    editar_moneda: Ledger.CLI.Currencies.CurrencyUpdate,
    borrar_moneda: Ledger.CLI.Currencies.CurrencyDelete,
    ver_moneda: Ledger.CLI.Currencies.CurrencyGet,
    alta_cuenta: Ledger.CLI.Transactions.AccountCreate,
    realizar_transferencia: Ledger.CLI.Transactions.TransferCreate,
    realizar_swap: Ledger.CLI.Transactions.SwapCreate,
    deshacer_transaccion: Ledger.CLI.Transactions.UndoTransactionCreate,
  }

  def main(argv \\ System.argv()) do
    argv
    |> Ledger.CLI.parse_args()
    |> select_subcommand()
  end

  defp select_subcommand({[cmd], args}) do
    Logger.debug("Comandos habilitados: #{inspect(Map.keys(@commands))}")
    case Map.fetch(@commands, cmd) do
      {:ok, module} ->
        Logger.debug("Comando seleccionado: #{inspect(cmd)}")
        module.run(args.options)

      :error ->
        IO.puts("Comando desconocido: #{cmd}")
    end
  end

  defp select_subcommand(_), do: IO.puts("Comando no reconocido o incompleto")
end
