defmodule Ledger.CLI.Options.CurrencyOptionsTest do
  use ExUnit.Case, async: true
  alias Ledger.CLI.Options.CurrencyOptions

  describe "create_currency_options/0" do
    test "devuelve opciones con nombre y tasa" do
      result = CurrencyOptions.create_currency_options()

      assert Keyword.has_key?(result, :currency_name)
      assert Keyword.has_key?(result, :usd_exchange_rate)
    end
  end

  describe "update_currency_options/0" do
    test "devuelve opciones con id y tasa" do
      result = CurrencyOptions.update_currency_options()

      assert Keyword.has_key?(result, :currency_id)
      assert Keyword.has_key?(result, :usd_exchange_rate)
    end
  end

  describe "delete_currency_options/0" do
    test "devuelve solo la opción de id" do
      result = CurrencyOptions.delete_currency_options()

      assert Keyword.has_key?(result, :currency_id)
      refute Keyword.has_key?(result, :currency_name)
      refute Keyword.has_key?(result, :usd_exchange_rate)
    end
  end

  describe "get_currency_options/0" do
    test "devuelve solo la opción de id" do
      result = CurrencyOptions.get_currency_options()

      assert Keyword.has_key?(result, :currency_id)
    end
  end
end
