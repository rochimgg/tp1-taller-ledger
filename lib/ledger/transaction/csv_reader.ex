defmodule Ledger.Transactions.CSVReader do
  alias Ledger.Types.Type

  def parse_line(line) do
    [
      transaction_id,
      timestamp,
      origin_currency,
      destination_currency,
      amount,
      origin_account,
      destination_account,
      type
    ] =
      String.split(line, ";")

    %{
      transaction_id: String.to_integer(transaction_id),
      timestamp: timestamp |> String.to_integer() |> DateTime.from_unix!(:second),
      origin_currency: origin_currency,
      destination_currency: if(destination_currency == "", do: nil, else: destination_currency),
      amount: parse_amount(amount),
      origin_account: origin_account,
      destination_account: if(destination_account == "", do: nil, else: destination_account),
      type: Type.from_string(type)
    }
  end

  defp parse_amount(amount) do
    case Float.parse(amount) do
      {val, ""} -> val
      :error -> String.to_integer(amount) |> Kernel./(1)
    end
  end
end
