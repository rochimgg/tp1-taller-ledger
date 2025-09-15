defmodule Ledger.Transactions.Service do
  alias Ledger.Schemas.Transaction
  alias Ledger.Transactions.CSVReader

def load_from_csv_file(path) do
  File.stream!(path)
  |> Stream.with_index(1)
  |> Enum.reduce_while([], fn {line, line_number}, acc ->
    line = String.trim(line)
    if line == "", do: {:cont, acc}  # ignorar líneas vacías
    attrs = CSVReader.parse_line(line)
    changeset = Transaction.changeset(%Transaction{}, attrs)
    if changeset.valid? do
      {:cont, [changeset | acc]}
    else
      {:halt, {:error, line_number}}
    end
  end)
end


  def list_transactions(transactions) do
    case transactions do
  {:error, line_number} -> IO.inspect({:error, line_number})

  changesets when is_list(changesets) ->
    IO.puts("Transacciones válidas:")
    Enum.each(Enum.reverse(changesets), fn cs ->
      IO.inspect(cs.changes)
    end)
    end
  end

end
