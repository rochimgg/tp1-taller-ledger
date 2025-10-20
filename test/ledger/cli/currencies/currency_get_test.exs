defmodule Ledger.CLI.Currencies.CurrencyGetTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ledger.Currencies.CurrenciesMock
  alias Ledger.CLI.Currencies.CurrencyGet

  setup :verify_on_exit!

  describe "run/2" do
    test "retorna error si falta el ID" do
      assert {:error, :missing_id} = CurrencyGet.run(%{currency_id: nil}, CurrenciesMock)
    end

    test "retorna error si el ID tiene formato inválido" do
      assert {:error, :invalid_id_format} = CurrencyGet.run(%{currency_id: "abc"}, CurrenciesMock)
    end

    test "llama al servicio y devuelve la moneda si se encuentra" do
      expect(CurrenciesMock, :get, fn 10 ->
        {:ok, %{id: 10, name: "USD"}}
      end)

      assert {:ok, %{id: 10, name: "USD"}} =
               CurrencyGet.run(%{currency_id: "10"}, CurrenciesMock)
    end

    test "retorna error si el servicio indica que no se encontró la moneda" do
      expect(CurrenciesMock, :get, fn 99 ->
        {:error, :not_found}
      end)

      assert {:error, :not_found} = CurrencyGet.run(%{currency_id: 99}, CurrenciesMock)
    end
  end
end
