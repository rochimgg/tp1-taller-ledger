defmodule Ledger.CLI.Subcommands.Tp1SubcommandsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ledger.CLI.Subcommands.Tp1Subcommands
  alias Ledger.CLI.Options.Tp1OptionsMock

  setup :verify_on_exit!

  test "get_all llama a balance_options y transaction_options del módulo inyectado" do
    expect(Tp1OptionsMock, :balance_options, fn -> [:mock_balance] end)
    expect(Tp1OptionsMock, :transaction_options, fn -> [:mock_transaction] end)

    result = Tp1Subcommands.get_all(Tp1OptionsMock)

    # Comprobamos que existan los subcomandos
    assert Keyword.has_key?(result, :balance)
    assert Keyword.has_key?(result, :transacciones)

    # Comprobamos que cada subcomando tenga las opciones correctas
    assert result[:balance][:options] == [:mock_balance]
    assert result[:transacciones][:options] == [:mock_transaction]
  end
end
