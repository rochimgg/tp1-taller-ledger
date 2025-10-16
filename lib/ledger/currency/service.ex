defmodule Ledger.Currency.Service do
  alias Ledger.Currency.Currency

  def load_from_csv_file(path, csv_reader \\ Ledger.Currency.CSVReader) do
    path
    |> csv_reader.stream!()
    |> Stream.with_index(1)
    |> Enum.reduce_while([], &process_line(&1, &2, csv_reader))
    |> finalize_result()
  end

  defp process_line({line, line_number}, acc, csv_reader) do
    line = String.trim(line)

    if line == "" do
      {:cont, acc}
    else
      attrs = csv_reader.parse_line(line)
      changeset = Currency.changeset(%Currency{}, attrs)

      if changeset.valid? do
        {:cont, [changeset.changes | acc]}
      else
        {:halt, {:error, line_number}}
      end
    end
  end

  def currency_lookup(service \\ __MODULE__, csv_reader \\ Ledger.Currency.CSVReader) do
    case service.load_from_csv_file("priv/data/moneda.csv", csv_reader) do
      {:ok, currencies} ->
        currencies
        |> Enum.reduce(%{}, fn cs, acc ->
          Map.put(acc, cs.currency_name, cs.usd_exchange_rate)
        end)

      {:error, line_number} ->
        IO.puts("Error cargando monedas: línea #{line_number}")
        System.halt(1)
    end
  end

  def list_currencies(result) do
    case result do
      {:error, line_number} ->
        IO.inspect({:error, line_number})

      {:ok, currencies} ->
        {:ok, currencies}
    end
  end

  defp finalize_result({:error, line_number}), do: {:error, line_number}
  defp finalize_result(changesets), do: {:ok, changesets}
end
