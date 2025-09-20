defmodule Ledger.Schemas.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "balance" do
    field(:currency_name, :string)
    field(:amount, :float)
  end

  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:currency_name, :amount])
    |> validate_required([:currency_name, :amount])
  end
end
