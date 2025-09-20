defmodule Ledger.Transactions.CSVReaderTest do
  use ExUnit.Case
  alias Ledger.Transactions.CSVReader
  alias Ledger.Types.Type

  describe "parse_line/1" do
    test "parses a full CSV line with all fields" do
      line = "1;1754937004;USD;USDT;100.5;userA;userB;transferencia"
      result = CSVReader.parse_line(line)

      assert result.transaction_id == 1
      assert result.timestamp == DateTime.from_unix!(1_754_937_004)
      assert result.origin_currency == "USD"
      assert result.destination_currency == "USDT"
      assert result.amount == 100.5
      assert result.origin_account == "userA"
      assert result.destination_account == "userB"
      assert result.type == Type.from_string("transferencia")
    end

    test "parses a line with empty destination_currency and destination_account" do
      line = "2;1755541804;BTC;;0.1;userB;;swap"
      result = CSVReader.parse_line(line)

      assert result.transaction_id == 2
      assert result.timestamp == DateTime.from_unix!(1_755_541_804)
      assert result.origin_currency == "BTC"
      assert result.destination_currency == nil
      assert result.amount == 0.1
      assert result.origin_account == "userB"
      assert result.destination_account == nil
      assert result.type == Type.from_string("swap")
    end

    test "parses amount as float even if integer string" do
      line = "3;1756751404;BTC;;50000;userC;;alta_cuenta"
      result = CSVReader.parse_line(line)

      assert result.amount == 50_000.0
    end

    test "raises if line is malformed" do
      line = "invalid;line;with;too;few;fields"
      assert_raise MatchError, fn ->
        CSVReader.parse_line(line)
      end
    end
  end
end
