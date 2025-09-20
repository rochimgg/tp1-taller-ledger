defmodule Ledger.ConstantsTest do
  use ExUnit.Case, async: true

  alias Ledger.Constants

  describe "transaction_options/0" do
    test "returns the base ledger options with required=false" do
      options = Constants.transaction_options() |> Enum.into(%{})

      # Verifico que todas las keys del base_options estén presentes
      assert Map.has_key?(options, :origin_account)
      assert Map.has_key?(options, :destination_account)
      assert Map.has_key?(options, :transaction_file_path)
      assert Map.has_key?(options, :currency)
      assert Map.has_key?(options, :output_file_path)

      # Por default, required debe ser false
      assert Keyword.get(options[:origin_account], :required) == false
    end
  end

  describe "balance_options/0" do
    test "overrides origin_account to required=true" do
      options = Constants.balance_options() |> Enum.into(%{})

      # origin_account debe ser requerido para balance
      assert Keyword.get(options[:origin_account], :required) == true

      # otras keys siguen presentes
      assert Map.has_key?(options, :destination_account)
      assert Map.has_key?(options, :transaction_file_path)
      assert Map.has_key?(options, :currency)
      assert Map.has_key?(options, :output_file_path)
    end
  end
end
