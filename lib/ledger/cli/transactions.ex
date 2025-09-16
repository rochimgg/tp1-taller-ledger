alias Ledger.Transactions.Service, as: Service

defmodule Ledger.CLI.Transactions do
  def run(opts) do
    IO.inspect(opts, label: "Ejecutando comando transacciones")

    Service.load_from_csv_file(opts[:transaction_file_path])
    |> filter_transactions(opts)
    |> IO.inspect(label: "Transacciones filtradas")
  end

  def filter_transactions({:ok, transactions}, opts) do
    do_filter(transactions, opts)
  end

  def filter_transactions({:error, reason}, _opts), do: {:error, reason}

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
