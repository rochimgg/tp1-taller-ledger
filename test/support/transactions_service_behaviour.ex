# test/support/ledger/transactions_service_behaviour.ex
defmodule Ledger.Transactions.ServiceBehaviour do
  @callback load_from_csv_file(String.t()) :: {:ok, list()} | {:error, any()}
end
