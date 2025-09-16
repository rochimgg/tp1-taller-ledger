defmodule Ledger.Currency.Service do
  alias Ledger.Schemas.Currency
  alias Ledger.Currency.CSVReader

  def load_from_csv_file(path) do
    path
    |> File.stream!()
    |> Stream.with_index(1)
    |> Enum.reduce_while({[], false}, &process_line/2)
    |> finalize_result()
  end

  defp process_line({line, line_number}, {acc, has_usd?}) do
    line = String.trim(line)

    if line == "" do
      {:cont, {acc, has_usd?}}
    else
      attrs = CSVReader.parse_line(line)
      changeset = Currency.changeset(%Currency{}, attrs)
      handle_changeset(changeset, acc, has_usd?, line_number)
    end
  end

  defp handle_changeset(changeset, acc, has_usd?, line_number) do
    if changeset.valid? do
      new_has_usd? = match?(%{currency: "USD"}, changeset.changes) or has_usd?
      {:cont, {[changeset | acc], new_has_usd?}}
    else
      {:halt, {:error, line_number}}
    end
  end

  defp finalize_result({:error, line_number}), do: {:error, line_number}

  defp finalize_result({changesets, true}),
    do: {:ok, changesets}

  defp finalize_result({_, false}),
    do: {:error, :missing_usd_rate}
end
