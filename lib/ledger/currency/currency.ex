defmodule Ledger.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "currency" do
    field(:currency_name, :string)
    field(:usd_exchange_rate, :float)
    timestamps()
  end

  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:currency_name, :usd_exchange_rate])
    |> validate_required([:currency_name, :usd_exchange_rate])
    |> validate_number(:usd_exchange_rate, greater_than: 0)
    |> validate_length(:currency_name, min: 3, max: 4)
    |> validate_format(:currency_name, ~r/^[A-Z]+$/, message: "el nombre de la moneda debe estar en mayúsculas")
    |> unique_constraint(:currency_name)
    |> validate_number(:price_usd, greater_than_or_equal_to: 0)
    |> maybe_prevent_name_change()
  end

  defp maybe_prevent_name_change(changeset) do
    if get_field(changeset, :id) && get_change(changeset, :currency_name) do
      add_error(changeset, :currency_name, "el nombre de la moneda no puede ser modificado")
    else
      changeset
    end
  end

end
