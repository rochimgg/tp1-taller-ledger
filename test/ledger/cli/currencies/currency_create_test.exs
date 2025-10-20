defmodule Ledger.CLI.Currencies.CurrencyCreateTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ledger.CLI.Currencies.CurrencyCreate
  alias Ledger.Currencies.CurrenciesMock
  alias Ecto.Changeset

  setup :verify_on_exit!

  test "devuelve error si falta currency_name" do
    opts = %{currency_name: nil, usd_exchange_rate: "1500"}
    assert {:error, :missing_currency_name} = CurrencyCreate.run(opts, CurrenciesMock)
  end

  test "devuelve error si falta usd_exchange_rate" do
    opts = %{currency_name: "ARS", usd_exchange_rate: nil}
    assert {:error, :missing_usd_exchange_rate} = CurrencyCreate.run(opts, CurrenciesMock)
  end

  test "crea exitosamente una moneda" do
    opts = %{currency_name: "ARS", usd_exchange_rate: "1500"}

    expect(CurrenciesMock, :insert, fn %{
                                         currency_name: "ARS",
                                         usd_exchange_rate: "1500"
                                       } ->
      {:ok, %{id: 1, currency_name: "ARS", usd_exchange_rate: 1500.0}}
    end)

    assert {:ok, %{currency_name: "ARS"}} = CurrencyCreate.run(opts, CurrenciesMock)
  end

  test "retorna error con changeset inválido" do
    opts = %{currency_name: "ARS", usd_exchange_rate: "1500"}

    changeset = %Changeset{
      valid?: false,
      errors: [currency_name: {"ya existe", []}]
    }

    expect(CurrenciesMock, :insert, fn _ -> {:error, changeset} end)

    assert {:error, ^changeset} = CurrencyCreate.run(opts, CurrenciesMock)
  end

  test "retorna error con mensaje de texto" do
    opts = %{currency_name: "ARS", usd_exchange_rate: "1500"}

    expect(CurrenciesMock, :insert, fn _ -> {:error, "falló el insert"} end)

    assert {:error, "falló el insert"} = CurrencyCreate.run(opts, CurrenciesMock)
  end

  test "retorna error desconocido si el servicio devuelve algo inesperado" do
    opts = %{currency_name: "ARS", usd_exchange_rate: "MIL QUINIENTOS"}

    expect(CurrenciesMock, :insert, fn _ -> :otra_cosa end)

    assert {:error, :unknown} = CurrencyCreate.run(opts, CurrenciesMock)
  end
end
