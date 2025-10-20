defmodule Ledger.CLI.Options.TransactionOptionsBehaviour do
  @callback create_account_options() :: list()
  @callback do_transfer_options() :: list()
  @callback do_swap_options() :: list()
  @callback undo_transaction_options() :: list()
  @callback get_transaction_options() :: list()
end
