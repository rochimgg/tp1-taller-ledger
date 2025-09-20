defmodule Ledger.CLI.BalanceMoxTest do
  use ExUnit.Case, async: true
  import Mox
  import ExUnit.CaptureIO
  alias Ledger.CLI.Balance
  alias Ledger.Types.Type

  setup :verify_on_exit!

  test "run/1 calculates balances and prints them" do
    transactions = [
      # Transacción de userA a userB → outcome
      %{
        origin_account: "userA",
        destination_account: "userB",
        origin_currency: "USD",
        destination_currency: "USD",
        amount: 50.0,
        type: Type.transferencia()
      },

      # Transacción de userB a userA → income
      %{
        origin_account: "userB",
        destination_account: "userA",
        origin_currency: "USD",
        destination_currency: "USD",
        amount: 100.0,
        type: Type.transferencia()
      },

      # Alta cuenta de userC, no afecta a userA
      %{
        origin_account: "userC",
        destination_account: nil,
        origin_currency: "USD",
        destination_currency: nil,
        amount: 10.0,
        type: Type.alta_cuenta()
      }
    ]

    currency_rates = %{"USD" => 1.0, "EUR" => 1.1}

    # Mock de TransactionService
    Ledger.Transactions.ServiceMock
    |> expect(:load_from_csv_file, fn _ -> {:ok, transactions} end)

    # Mock de CurrencyService
    Ledger.Currency.ServiceMock
    |> expect(:currency_lookup, fn -> currency_rates end)

    opts = %{transaction_file_path: "ignored.csv", origin_account: "userA", currency: "USD"}

    output =
      capture_io(fn ->
        Balance.run(opts, Ledger.Transactions.ServiceMock, Ledger.Currency.ServiceMock)
      end)

    assert output =~ "USD=50.000000"
    assert output =~ "MONEDA=BALANCE"
  end
end
