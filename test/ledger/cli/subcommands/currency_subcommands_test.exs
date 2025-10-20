defmodule Ledger.CLI.Subcommands.CurrencySubcommandsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ledger.CLI.Subcommands.CurrencySubcommands
  alias Ledger.CLI.Options.CurrencyOptionsMock

  setup :verify_on_exit!

  describe "get_all/1 con Mox" do
    test "llama a todas las funciones del módulo de opciones" do
      expect(CurrencyOptionsMock, :create_currency_options, fn -> [:mock_create_currency] end)
      expect(CurrencyOptionsMock, :update_currency_options, fn -> [:mock_update_currency] end)
      expect(CurrencyOptionsMock, :delete_currency_options, fn -> [:mock_delete_currency] end)
      expect(CurrencyOptionsMock, :get_currency_options, fn -> [:mock_get_currency] end)

      result = CurrencySubcommands.get_all(CurrencyOptionsMock)

      assert Keyword.has_key?(result, :crear_moneda)
      assert Keyword.has_key?(result, :editar_moneda)
      assert Keyword.has_key?(result, :borrar_moneda)
      assert Keyword.has_key?(result, :ver_moneda)

      assert result[:crear_moneda][:options] == [:mock_create_currency]
      assert result[:editar_moneda][:options] == [:mock_update_currency]
      assert result[:borrar_moneda][:options] == [:mock_delete_currency]
      assert result[:ver_moneda][:options] == [:mock_get_currency]
    end
  end
end
