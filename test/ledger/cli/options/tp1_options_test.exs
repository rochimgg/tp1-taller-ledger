defmodule Ledger.CLI.Options.Tp1OptionsTest do
  use ExUnit.Case, async: true
  alias Ledger.CLI.Options.Tp1Options

  describe "transaction_options/0" do
    test "devuelve las opciones base con required en false" do
      result = Tp1Options.transaction_options()

      # Es una keyword list (porque Enum.map produce [{atom, keyword()}])
      assert Keyword.keyword?(result)

      # Todas las opciones tienen required: false
      Enum.each(result, fn {_key, opts} ->
        assert Keyword.get(opts, :required) == false
      end)
    end
  end

  describe "balance_options/0" do
    test "devuelve opciones con origin_account requerido" do
      result = Tp1Options.balance_options()

      # Encontramos la opción de cuenta origen
      origin_opts = Keyword.get(result, :origin_account)

      assert origin_opts[:required] == true
      assert origin_opts[:long] == "--c1"

      # Las demás siguen con required: false
      Enum.each(result, fn
        {:origin_account, _} -> :ok
        {_key, opts} -> assert Keyword.get(opts, :required) == false
      end)
    end
  end

  test "agrega required: false cuando no está definido" do
    base = %{test_opt: [long: "--x"]}

    result = Tp1Options.ledger_options_tp1(base)

    # Verificamos que incluye nuestra opción con required: false
    test_opt = Keyword.get(result, :test_opt)
    assert test_opt[:long] == "--x"
    assert test_opt[:required] == false

    # Verificamos que las demás siguen existiendo
    assert Keyword.has_key?(result, :origin_account)
    assert Keyword.has_key?(result, :transaction_file_path)
  end

  describe "origin_account_option/0" do
    test "devuelve el mapa esperado" do
      result = Tp1Options.origin_account_option()
      assert Map.has_key?(result, :origin_account)

      opts = result.origin_account
      assert opts[:long] == "--c1"
      assert opts[:help] =~ "cuenta origen"
    end
  end

  describe "origin_account_required_option/0" do
    test "devuelve el mapa con required: true" do
      result = Tp1Options.origin_account_required_option()

      assert Map.has_key?(result, :origin_account)
      opts = result.origin_account
      assert opts[:required] == true
    end
  end
end
