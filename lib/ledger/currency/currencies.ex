defmodule Ledger.Currencies do
  alias Ledger.Currencies.Currency
  alias Ledger.Repo

  def list_currencies do
    Repo.all(Currency)
  end

  def create_currency(attrs) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end
end
