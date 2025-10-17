defmodule Ledger.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ledger.Transactions.Transaction, as: Transaction

  schema "currencies" do
    field(:currency_name, :string)
    field(:usd_exchange_rate, :float)
    timestamps()

    has_many :origin_currency_in_transactions, Transaction, foreign_key: :origin_currency_id
    has_many :destination_currency_in_transactions, Transaction, foreign_key: :destination_currency_id
  end

  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:currency_name, :usd_exchange_rate])
    |> validate_required([:currency_name, :usd_exchange_rate], message: "este campo es obligatorio")
    |> validate_number(:usd_exchange_rate, greater_than: 0, message: "la tasa de cambio debe ser un número positivo")
    |> validate_length(:currency_name, min: 3, max: 4, message: "el nombre de la moneda debe tener entre 3 y 4 caracteres")
    |> validate_format(:currency_name, ~r/^[A-Z]+$/, message: "el nombre de la moneda debe estar en mayúsculas")
    |> unique_constraint(:currency_name, name: :unique_currency_name_index, message: "el nombre de la moneda ya existe")
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
