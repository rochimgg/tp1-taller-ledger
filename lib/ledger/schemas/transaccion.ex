alias Tipo

defmodule Ledger.Schemas.Transaccion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transacciones" do
    field :id_transaccion, :id
    field :timestamp, :utc_datetime_usec
    field :moneda_origen, :string
    field :moneda_destino, :string
    field :monto, :float
    field :cuenta_origen, :string
    field :cuenta_destino, :string
    field :tipo, :string
  end

  def changeset(transaccion, attrs) do
    transaccion
    |> cast(attrs, [:timestamp, :moneda_origen, :moneda_destino, :monto, :cuenta_origen, :cuenta_destino, :tipo])
    |> validate_required([:timestamp, :moneda_origen, :monto, :cuenta_origen, :tipo])
    |> validate_number(:monto, greater_than: 0)
    |> validate_inclusion(:tipo, Tipo.all())
  end

end
