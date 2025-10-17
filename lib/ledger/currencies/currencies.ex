defmodule Ledger.Currencies.Currencies do
  alias Ledger.Currencies.Currency, as: Currency
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

  def get_currency(id) when is_integer(id) do
    case Repo.get(Currency, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  defp create_currency(attrs) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end
end
