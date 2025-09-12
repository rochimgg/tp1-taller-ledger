defmodule Ledger.CLI do

  alias Ledger.Constants, as: Constants


  def normalize_custom_flags(argv) do
    Enum.map(argv, &normalize_flag/1)
  end

  defp normalize_flag(arg) do
    case arg do
      "-" <> suffix -> "--" <> suffix
      other -> other
    end
  end

  def optimus do
    Optimus.new!(
      name: "ledger",
      version: "0.1.0",
      allow_unknown_args: true,
      parse_double_dash: true,
      subcommands: [
        balance: [
          name: "balance",
          about: "Listar el balance de una cuenta",
          options: Constants.balance_options()
        ],
        transacciones: [
          name: "transacciones",
          about: "Listar transacciones",
          options: Constants.transaction_options()
        ]
      ]
    )
  end
end
