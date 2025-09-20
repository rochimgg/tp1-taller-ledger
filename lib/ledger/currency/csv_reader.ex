defmodule Ledger.Currency.CSVReader do
  def stream!(path), do: File.stream!(path)

  def parse_line(line) do
    [currency_name, exchange_rate] = String.split(line, ";")
    %{
      currency_name: currency_name,
      usd_exchange_rate: parse_amount(exchange_rate)
    }
  end

  defp parse_amount(amount) do
    case Float.parse(amount) do
      {val, ""} -> val
      :error -> String.to_integer(amount) / 1
    end
  end
end
