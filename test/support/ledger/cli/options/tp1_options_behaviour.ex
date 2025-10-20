defmodule Ledger.CLI.Options.Tp1OptionsBehaviour do
  @callback balance_options() :: list()
  @callback transaction_options() :: list()
end
