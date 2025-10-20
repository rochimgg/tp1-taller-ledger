defmodule Ledger.CLI.Subcommands.Tp1Subcommands do
  alias Ledger.CLI.Options.Tp1Options

  def get_all(options_module \\ Tp1Options) do
    [
      balance(options_module),
      transactions(options_module)
    ]
    |> Enum.flat_map(&Map.to_list/1)
  end

  defp balance(options_module) do
    %{
      balance: [
        name: "balance",
        about: "Listar el balance de una cuenta",
        options: options_module.balance_options()
      ]
    }
  end

  defp transactions(options_module) do
    %{
      transacciones: [
        name: "transacciones",
        about: "Listar transacciones",
        options: options_module.transaction_options()
      ]
    }
  end
end
