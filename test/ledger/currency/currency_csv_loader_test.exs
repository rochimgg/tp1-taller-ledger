defmodule Ledger.Currency.CSVReaderTest do
  use ExUnit.Case

  alias Ledger.Currency.CSVReader

  describe "parse_line/1" do
    test "parses a line with a float exchange rate" do
      line = "USD;1.0"
      result = CSVReader.parse_line(line)

      assert result == %{currency_name: "USD", usd_exchange_rate: 1.0}
    end

    test "parses a line with an integer exchange rate" do
      line = "EUR;2"
      result = CSVReader.parse_line(line)

      assert result == %{currency_name: "EUR", usd_exchange_rate: 2.0}
    end

    test "raises if the line is malformed" do
      line = "GBP"  # missing exchange rate

      assert_raise MatchError, fn ->
        CSVReader.parse_line(line)
      end
    end
  end

  describe "stream!/1" do
    test "returns a stream from a file" do
      # Create a temporary CSV file
      path = Path.join(System.tmp_dir!(), "currencies.csv")
      File.write!(path, "USD;1.0\nEUR;1.1\n")

      stream = CSVReader.stream!(path)
      lines = Enum.to_list(stream) |> Enum.map(&String.trim/1)

      assert lines == ["USD;1.0", "EUR;1.1"]

      # Clean up
      File.rm!(path)
    end
  end
end
