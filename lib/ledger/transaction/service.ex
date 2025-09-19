defmodule Ledger.Transactions.Service do
  alias Ledger.Schemas.Transaction
  alias Ledger.Transactions.CSVReader

  def load_from_csv_file(path) do
    path
    |> File.stream!()
    |> Stream.with_index(1)
    |> Enum.reduce_while([], &process_line/2)
    |> finalize_result()
  end

  def list_transactions(result) do
    case result do
      {:error, line_number} ->
        IO.inspect({:error, line_number})

      {:ok, transactions} ->
        {:ok, transactions}
    end
  end

  defp process_line({line, line_number}, acc) do
    line = String.trim(line)

    if line == "" do
      {:cont, acc}
    else
      attrs = CSVReader.parse_line(line)
      changeset = Transaction.changeset(%Transaction{}, attrs)
      handle_changeset(changeset, acc, line_number)
    end
  end

  defp handle_changeset(changeset, acc, line_number) do
    if changeset.valid? do
      {:cont, [changeset.changes | acc]}
    else
      {:halt, {:error, line_number}}
    end
  end

  defp finalize_result({:error, line_number}), do: {:error, line_number}
  defp finalize_result(transactions), do: {:ok, transactions}
end
