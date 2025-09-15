alias Ledger.Types.Type, as: Type

defmodule Ledger.Schemas.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field(:id_transaction, :id)
    field(:timestamp, :utc_datetime_usec)
    field(:origin_currency, :string)
    field(:destination_currency, :string)
    field(:amount, :float)
    field(:origin_account, :string)
    field(:destination_account, :string)
    field(:type, Ecto.Enum, values: Type.all())
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :timestamp,
      :origin_currency,
      :destination_currency,
      :amount,
      :origin_account,
      :destination_account,
      :type
    ])
    |> validate_required([:timestamp, :origin_currency, :amount, :origin_account, :type])
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:type, Type.all())
  end
end
