defmodule Ledger.Schemas.Moneda do
  use Ecto.Schema
  import Ecto.Changeset

  schema "monedas" do
    field :nombre_moneda, :string
    field :precio_usd, :float
  end

  def changeset(moneda, attrs) do
    moneda
    |> cast(attrs, [:nombre_moneda, :precio_usd])
    |> validate_required([:nombre_moneda, :precio_usd])
    |> validate_number(:precio_usd, greater_than: 0)
  end

end
