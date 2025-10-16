defmodule Ledger.CLI do
  alias Ledger.Constants, as: Constants

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
        ],
        crear_moneda: [
          name: "crear_moneda",
          about: "Crear una nueva moneda",
          options: Constants.currency_creation_options()
        ]
      ]
    )
  end
end
