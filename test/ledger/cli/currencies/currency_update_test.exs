defmodule Ledger.CLI.Currencies.CurrencyUpdateTest do
  use ExUnit.Case, async: true
  import Mox
  alias Ledger.Currencies.CurrenciesMock
  alias Ledger.CLI.Currencies.CurrencyUpdate

  setup :verify_on_exit!

  test "actualiza una moneda exitosamente" do
    opts = %{currency_id: 1, usd_exchange_rate: 1200.5}
    updated_currency = %{id: 1, currency_name: "ARS", usd_exchange_rate: 1200.5}

    expect(CurrenciesMock, :update_currency, fn 1, %{usd_exchange_rate: 1200.5} ->
      {:ok, updated_currency}
    end)

    assert {:ok, ^updated_currency} = CurrencyUpdate.run(opts, CurrenciesMock)
  end

  test "retorna error si el update falla" do
    opts = %{currency_id: 1, usd_exchange_rate: 999.9}

    expect(CurrenciesMock, :update_currency, fn 1, %{usd_exchange_rate: 999.9} ->
      {:error, :not_found}
    end)

    assert {:error, :not_found} = CurrencyUpdate.run(opts, CurrenciesMock)
  end
end
