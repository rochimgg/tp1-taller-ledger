defmodule Ledger.Schemas.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "currency" do
    field(:currency_name, :string)
    field(:usd_exchange_rate, :float)
  end

  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:currency_name, :usd_exchange_rate])
    |> validate_required([:currency_name, :usd_exchange_rate])
    |> validate_number(:usd_exchange_rate, greater_than: 0)
  end
end
