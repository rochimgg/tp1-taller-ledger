alias Ledger.Transactions.Service, as: TransactionService

defmodule Ledger.CLI.Transactions do
  def run(opts, transaction_service \\ TransactionService) do
    IO.inspect(opts, label: "Ejecutando comando transacciones")

    transaction_service.load_from_csv_file(opts[:transaction_file_path])
    |> filter_transactions(opts)
    |> IO.inspect(label: "Transacciones filtradas")
  end

  defp filter_transactions({:ok, transactions}, opts) do
    do_filter(transactions, opts)
  end

  defp filter_transactions({:error, reason}, _opts), do: {:error, reason}

  defp do_filter(transactions, opts) do
    Enum.filter(transactions, fn transaction ->
      Enum.all?(opts, fn
        {_key, nil} -> true
        {:transaction_file_path, _} -> true
        {:output_file_path, _} -> true
        {key, value} -> Map.get(transaction, key) == value
      end)
    end)
  end
end
