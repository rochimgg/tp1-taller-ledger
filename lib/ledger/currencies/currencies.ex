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

  @spec update_currency(
          any(),
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: any()
  def update_currency(id, attrs) do
    currency = Repo.get(Currency, id)
    changeset = Currency.changeset(currency, attrs)
    Repo.update(changeset)
  end

  def get_currency(id) when is_integer(id) do
    case Repo.get(Currency, id) do
      nil -> {:error, :not_found}
      currency -> {:ok, currency}
    end
  end

  defp create_currency(attrs) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end
end
