require Logger
defmodule Ledger do
  @commands %{
    balance: Ledger.CLI.Balance,
    transacciones: Ledger.CLI.Transactions,
    crear_usuario: Ledger.CLI.UserCreate,
    editar_usuario: Ledger.CLI.UserUpdate,
    borrar_usuario: Ledger.CLI.UserDelete,
    ver_usuario: Ledger.CLI.UserGet,
    crear_moneda: Ledger.CLI.CurrencyCreate,
    editar_moneda: Ledger.CLI.CurrencyUpdate,
    borrar_moneda: Ledger.CLI.CurrencyDelete,
    ver_moneda: Ledger.CLI.CurrencyGet,
    alta_cuenta: Ledger.CLI.AccountCreate,
    realizar_transferencia: Ledger.CLI.TransferCreate,
    realizar_swap: Ledger.CLI.SwapCreate,
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
