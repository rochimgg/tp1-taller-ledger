defmodule Ledger.Currency.CSVReader do
  def parse_line(line) do
    [currency_name, exchange_rate] =
      String.split(line, "=")

    %{
      currency_name: String.capitalize(currency_name),
      exchange_rate: parse_amount(exchange_rate) |> Float.round(6)
    }
  end

  defp parse_amount(amount) do
    case Float.parse(amount) do
      {val, ""} -> val
      :error -> String.to_integer(amount) |> Kernel./(1)
    end
  end
end
