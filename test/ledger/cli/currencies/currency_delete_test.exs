defmodule Ledger.CLI.Currencies.CurrencyDeleteTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ledger.Currencies.CurrenciesMock

  setup :verify_on_exit!

  test "borra la moneda exitosamente" do
    opts = %{currency_id: 1}

    expect(CurrenciesMock, :delete, fn 1 -> {:ok, %{id: 1, currency_name: "ARG"}} end)

    assert {:ok, %{id: 1}} =
             Ledger.CLI.Currencies.CurrencyDelete.run(opts, CurrenciesMock)
  end

  test "retorna error cuando no se encuentra la moneda" do
    opts = %{currency_id: 2}

    expect(CurrenciesMock, :delete, fn 2 -> {:error, :not_found} end)

    assert {:error, :not_found} =
             Ledger.CLI.Currencies.CurrencyDelete.run(opts, CurrenciesMock)
  end

  test "retorna error cuando no se pasa currency_id" do
    opts = %{}

    assert {:error, :missing_currency_id} =
             Ledger.CLI.Currencies.CurrencyDelete.run(opts, CurrenciesMock)
  end
end
