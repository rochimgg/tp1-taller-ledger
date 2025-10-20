defmodule Ledger.Currency.ServiceBehaviour do
  @callback load_from_csv_file(String.t()) :: {:ok, list()} | {:error, any()}
  @callback currency_lookup() :: map()
end
