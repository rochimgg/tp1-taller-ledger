defmodule Ledger.CLI.Options.TransactionOptionsTest do
  use ExUnit.Case, async: true

  alias Ledger.CLI.Options.TransactionOptions

  describe "create_account_options/0" do
    test "devuelve las opciones esperadas" do
      options = TransactionOptions.create_account_options()

      keys = Enum.map(options, &elem(&1, 0))
      assert :user_id in keys
      assert :currency_id in keys
      assert :amount in keys

      amount_opt = Keyword.get(options, :amount)
      assert amount_opt[:required] == true
      assert amount_opt[:long] == "--a"
    end
  end

  describe "do_transfer_options/0" do
    test "devuelve las opciones esperadas" do
      options = TransactionOptions.do_transfer_options()

      keys = Enum.map(options, &elem(&1, 0))
      assert :origin_user_id in keys
      assert :destination_user_id in keys
      assert :currency_id in keys
      assert :amount in keys

      assert Keyword.get(options, :origin_user_id)[:long] == "--o"
      assert Keyword.get(options, :destination_user_id)[:long] == "--d"
    end
  end

  describe "do_swap_options/0" do
    test "devuelve las opciones esperadas" do
      options = TransactionOptions.do_swap_options()

      keys = Enum.map(options, &elem(&1, 0))
      assert :user_id in keys
      assert :origin_currency_id in keys
      assert :destination_currency_id in keys
      assert :amount in keys

      assert Keyword.get(options, :origin_currency_id)[:long] == "--mo"
      assert Keyword.get(options, :destination_currency_id)[:long] == "--md"
    end
  end

  describe "undo_transaction_options/0" do
    test "devuelve solo el id de transacción" do
      options = TransactionOptions.undo_transaction_options()

      assert Enum.map(options, &elem(&1, 0)) == [:transaction_id]
      assert Keyword.get(options, :transaction_id)[:required] == true
    end
  end

  describe "get_transaction_options/0" do
    test "devuelve solo el id de transacción" do
      options = TransactionOptions.get_transaction_options()

      assert Enum.map(options, &elem(&1, 0)) == [:transaction_id]
      assert Keyword.get(options, :transaction_id)[:value_name] == "ID_TRANSACCION"
    end
  end
end
