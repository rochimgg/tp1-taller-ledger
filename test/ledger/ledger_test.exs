defmodule LedgerTest do
  use ExUnit.Case
  doctest LedgerTest

  test "greets the world" do
    assert Ledger.hello() == :world
  end
end
