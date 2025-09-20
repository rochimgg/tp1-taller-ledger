defmodule Ledger.CLITest do
  use ExUnit.Case

  alias Ledger.CLI

  describe "parse_args/1" do
    test "parsea argumentos de balance correctamente" do
      argv = ["balance", "--c1", "userA", "--m", "USD"]

      {subcommand, result} = CLI.parse_args(argv)

      # Optimus devuelve los subcomandos como lista
      assert subcommand == [:balance]

      # Verificamos que las opciones se hayan parseado
      assert result.options.origin_account == "userA"
      assert result.options.currency == "USD"
    end
  end

  describe "normalize_flags/1 effect through parse_args/1" do
    test "convierte -x en --x y deja otros intactos" do
      argv = ["balance", "-c1", "userA", "--m", "USD"]

      {subcommand, result} = CLI.parse_args(argv)

      assert subcommand == [:balance]
      assert result.options.origin_account == "userA"
      assert result.options.currency == "USD"
    end
  end

  describe "optimus/0" do
    test "crea subcomandos balance y transacciones" do
      cli = Ledger.CLI.optimus()

      subcommand_names =
        cli.subcommands
        |> Enum.map(fn %Optimus{name: name} -> String.to_atom(name) end)

      assert :balance in subcommand_names
      assert :transacciones in subcommand_names
    end
  end
end
