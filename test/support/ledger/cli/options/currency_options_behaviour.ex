defmodule Ledger.CLI.Options.CurrencyOptionsBehaviour do
  @callback create_currency_options() :: list(map())
  @callback update_currency_options() :: list(map())
  @callback delete_currency_options() :: list(map())
  @callback get_currency_options() :: list(map())
end
