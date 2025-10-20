defmodule Ledger.CLITest do
  require Logger
  use ExUnit.Case, async: true
  import Mox

  alias Ledger.CLI
  alias Ledger.CLI.Subcommands.CurrencySubcommandMock

  setup :verify_on_exit!

  test "load_all_subcommands usa los subcommands inyectados" do
    expect(CurrencySubcommandMock, :get_all, fn ->
      [
        ver_moneda: [
          name: "ver_moneda",
          about: "Obtener una moneda existente",
          options: [
            currency_id: [
              long: "--id",
              value_name: "ID_MONEDA",
              help: "Id de la moneda (obligatorio)",
              required: true
            ]
          ]
        ]
      ]
    end)

    {subcommand, parsed} = CLI.parse_args(["ver_moneda", "--id=1"], [CurrencySubcommandMock])
    assert Enum.member?(subcommand, :ver_moneda)
    assert Map.has_key?(parsed.options, :currency_id)
  end
end
