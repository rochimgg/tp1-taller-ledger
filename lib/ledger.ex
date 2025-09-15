defmodule Ledger do
  alias Ledger.CLI.Balance, as: Balance
  alias Ledger.CLI.Transactions, as: Transactions

  def main(argv \\ System.argv()) do
    argv
    |> Ledger.CLI.parse_args()
    |> select_subcommand()
  end

  defp select_subcommand({[:balance], args}) do
    Balance.run(args.options)
  end

  defp select_subcommand({[:transacciones], args}) do
    Transactions.run(args.options)
  end

  defp select_subcommand(_other) do
    IO.puts("Comando no reconocido o incompleto")
  end
end
