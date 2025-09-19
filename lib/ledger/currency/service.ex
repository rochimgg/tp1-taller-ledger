defmodule Ledger.Currency.Service do
  alias Ledger.Schemas.Currency
  alias Ledger.Currency.CSVReader

  def load_from_csv_file(path) do
    path
    |> File.stream!()
    |> Stream.with_index(1)
    |> Enum.reduce_while([], &process_line/2)
    |> finalize_result()
  end

  def currency_lookup do
    {:ok, currencies} = Ledger.Currency.Service.load_from_csv_file("priv/data/moneda.csv")

    currencies
    |> Enum.map(fn cs -> cs.changes.currency_name end)
    |> MapSet.new()
  end

  def list_currencies(result) do
    case result do
      {:error, line_number} ->
        IO.inspect({:error, line_number})

      {:ok, currencies} ->
        {:ok, currencies}
    end
  end

  defp process_line({line, line_number}, acc) do
    line = String.trim(line)

    if line == "" do
      {:cont, acc}
    else
      attrs = CSVReader.parse_line(line)
      changeset = Currency.changeset(%Currency{}, attrs)
      handle_changeset(changeset, acc, line_number)
    end
  end

  defp handle_changeset(changeset, acc, line_number) do
    if changeset.valid? do
      {:cont, [changeset | acc]}
    else
      {:halt, {:error, line_number}}
    end
  end

  defp finalize_result({:error, line_number}), do: {:error, line_number}
  defp finalize_result(changesets), do: {:ok, Enum.reverse(changesets)}
end
