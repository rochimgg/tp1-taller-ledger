defmodule Ledger.Currency.ServiceTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ledger.Currencies.Service

  setup :verify_on_exit!

  test "load_from_csv_file returns changesets for valid CSV lines" do
    Ledger.Currency.CSVReaderMock
    |> expect(:stream!, fn _ -> ["USD,1.0", "EUR,1.1"] end)
    |> expect(:parse_line, fn "USD,1.0" -> %{currency_name: "USD", usd_exchange_rate: 1.0} end)
    |> expect(:parse_line, fn "EUR,1.1" -> %{currency_name: "EUR", usd_exchange_rate: 1.1} end)

    {:ok, result} = Service.load_from_csv_file("ignored.csv", Ledger.Currency.CSVReaderMock)

    assert Enum.any?(result, &(&1.currency_name == "USD"))
    assert Enum.any?(result, &(&1.currency_name == "EUR"))
  end
end
