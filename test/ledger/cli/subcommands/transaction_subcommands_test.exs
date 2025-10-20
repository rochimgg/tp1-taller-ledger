defmodule Ledger.CLI.Subcommands.TransactionSubcommandsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ledger.CLI.Subcommands.TransactionSubcommands
  alias Ledger.CLI.Options.TransactionOptionsMock

  setup :verify_on_exit!

  test "get_all llama a todas las funciones del módulo inyectado" do
    expect(TransactionOptionsMock, :create_account_options, fn -> [:mock_create_account] end)
    expect(TransactionOptionsMock, :do_transfer_options, fn -> [:mock_transfer] end)
    expect(TransactionOptionsMock, :do_swap_options, fn -> [:mock_swap] end)
    expect(TransactionOptionsMock, :undo_transaction_options, fn -> [:mock_undo] end)
    expect(TransactionOptionsMock, :get_transaction_options, fn -> [:mock_get] end)

    result = TransactionSubcommands.get_all(TransactionOptionsMock)

    # Comprobamos que existan todos los subcomandos
    assert Keyword.has_key?(result, :alta_cuenta)
    assert Keyword.has_key?(result, :realizar_transferencia)
    assert Keyword.has_key?(result, :realizar_swap)
    assert Keyword.has_key?(result, :deshacer_transaccion)
    assert Keyword.has_key?(result, :ver_transaccion)

    # Comprobamos que cada subcomando tenga las opciones mockeadas
    assert result[:alta_cuenta][:options] == [:mock_create_account]
    assert result[:realizar_transferencia][:options] == [:mock_transfer]
    assert result[:realizar_swap][:options] == [:mock_swap]
    assert result[:deshacer_transaccion][:options] == [:mock_undo]
    assert result[:ver_transaccion][:options] == [:mock_get]
  end
end
