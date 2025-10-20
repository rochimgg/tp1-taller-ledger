require Logger
defmodule Ledger.CLI do
  @default_subcommands [
    Ledger.CLI.Subcommands.Tp1Subcommands,
    Ledger.CLI.Subcommands.UserSubcommands,
    Ledger.CLI.Subcommands.CurrencySubcommands,
    Ledger.CLI.Subcommands.TransactionSubcommands
  ]

  def parse_args(argv \\ System.argv(), subcommands \\ @default_subcommands) do
    argv
    |> tap(&Logger.debug("Argumentos: #{inspect(&1)}"))
    |> normalize_flags()
    |> tap(&Logger.debug("Argumentos nomalizados: #{inspect(&1)}"))
    |> (fn args -> Optimus.parse!(optimus(subcommands), args) end).()
  end

  defp normalize_flags(argv) do
    Enum.map(argv, fn
      "--" <> _ = arg -> arg
      "-" <> suffix -> "--" <> suffix
      other -> other
    end)
  end

  def optimus(subcommands) do
    Optimus.new!(
      name: "ledger",
      version: "2.0.1",
      allow_unknown_args: true,
      parse_double_dash: true,
      subcommands: load_all_subcommands(subcommands)
    )
  end

  defp load_all_subcommands(modules) do
    modules
    |> Enum.flat_map(& &1.get_all())
    |> tap(&Logger.debug("Subcomandos cargados: #{inspect(&1)}"))
  end
end
