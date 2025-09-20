defmodule Ledger.CLI.TransactionsMoxTest do
  use ExUnit.Case, async: true
  import Mox
  import ExUnit.CaptureIO

  alias Ledger.CLI.Transactions
  alias Ledger.Transactions.ServiceMock

  setup :verify_on_exit!

  test "run/2 filters and prints transactions" do
    transactions = [
      %{origin_account: "userA", amount: 100.0},
      %{origin_account: "userB", amount: 50.0}
    ]

    # Mock the Service
    ServiceMock
    |> expect(:load_from_csv_file, fn "ignored.csv" -> {:ok, transactions} end)

    opts = %{transaction_file_path: "ignored.csv", origin_account: "userA"}

    output =
      capture_io(fn ->
        Transactions.run(opts, ServiceMock)
      end)

    assert output =~ "Transacciones filtradas"
    assert output =~ "userA"
    refute output =~ "userB"
  end
end
