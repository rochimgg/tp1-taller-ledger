defmodule Ledger.Currency.Currencies do
  alias Ledger.Currency.Currency, as: Currency
  alias Ledger.Repo, as: Repo

  def list_currencies do
    Repo.all(Currency)
  end

  def create_currency(currency_name, usd_exchange_rate) do
    create_currency(%{
      currency_name: currency_name,
      usd_exchange_rate: String.to_float(usd_exchange_rate)
    })
  end

  defp create_currency(attrs) do
    IO.inspect(attrs, label: "attrs")

    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end

end
