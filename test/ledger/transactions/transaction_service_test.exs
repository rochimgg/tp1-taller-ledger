defmodule Ledger.Transactions.ServiceTest do
  use ExUnit.Case
  alias Ledger.Transactions.Service

  # Mock CSV reader to avoid actual file I/O
  defmodule MockReader do
    def stream!(_path), do: [
      "", # empty line should be ignored
      "1;1754937004;USD;;100.5;userA;;transferencia",
      "2;1755541804;BTC;USDT;0.1;userB;;swap",
      "INVALID LINE" # this should produce an error
    ]

    def parse_line("1;1754937004;USD;;100.5;userA;;transferencia") do
      %{
        transaction_id: 1,
        timestamp: DateTime.from_unix!(1_754_937_004),
        origin_currency: "USD",
        destination_currency: nil,
        amount: 100.5,
        origin_account: "userA",
        destination_account: nil,
        type: :transferencia
      }
    end

    def parse_line("2;1755541804;BTC;USDT;0.1;userB;;swap") do
      %{
        transaction_id: 2,
        timestamp: DateTime.from_unix!(1_755_541_804),
        origin_currency: "BTC",
        destination_currency: "USDT",
        amount: 0.1,
        origin_account: "userB",
        destination_account: nil,
        type: :swap
      }
    end

    def parse_line("INVALID LINE"), do: %{transaction_id: nil} # invalid changeset
  end

  describe "list_transactions/1" do
    test "wraps error result" do
      assert {:error, 2} = Service.list_transactions({:error, 2})
    end

    test "wraps ok result" do
      transactions = [%{transaction_id: 1}]
      assert {:ok, _transactions} = Service.list_transactions({:ok, transactions})
    end
  end
end
