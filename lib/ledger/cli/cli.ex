defmodule Ledger.CLI do
  alias Ledger.CLI.{
    Tp1Subcommands,
    UserSubcommands,
    CurrencySubcommands,
    TransactionSubcommands
  }

  @subcommand_modules [
    Tp1Subcommands,
    UserSubcommands,
    CurrencySubcommands,
    TransactionSubcommands
  ]

  def parse_args(argv \\ System.argv()) do
    argv
    |> normalize_flags()
    |> (fn args -> Optimus.parse!(optimus(), args) end).()
  end

  defp normalize_flags(argv) do
    Enum.map(argv, fn
      arg ->
        case arg do
          "--" <> _ -> arg
          "-" <> suffix -> "--" <> suffix
          other -> other
        end
    end)
  end

  def optimus do
    Optimus.new!(
      name: "ledger",
      version: "2.0.1",
      allow_unknown_args: true,
      parse_double_dash: true,
      subcommands: load_all_subcommands()
    )
  end

defp load_all_subcommands do
  @subcommand_modules
  |> Enum.flat_map(& &1.get_all())
end


end
