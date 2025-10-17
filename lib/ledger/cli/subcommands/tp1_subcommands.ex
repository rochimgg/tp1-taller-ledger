
defmodule Ledger.CLI.Tp1Subcommands do

  alias Ledger.CLI.Tp1Options, as: Tp1Options

  def get_all do
    [
      balance(),
      transactions()
    ]
    |> Enum.flat_map(&Map.to_list/1)

  end

  defp balance do
      %{
        balance: [
          name: "balance",
          about: "Listar el balance de una cuenta",
          options: Tp1Options.balance_options()
        ]
      }
    end

    defp transactions do
      %{
        transacciones: [
          name: "transacciones",
          about: "Listar transacciones",
          options: Tp1Options.transaction_options()
        ]
      }
    end
end
