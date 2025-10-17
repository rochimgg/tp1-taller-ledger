defmodule Ledger.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ledger.Users.User, as: User
  alias Ledger.Currencies.Currency, as: Currency
  alias Ledger.Types.Type, as: Type


  schema "transactions" do
    field :timestamp, :utc_datetime_usec
    field :amount, :float
    field :type, :string

    belongs_to :origin_currency, Currency, foreign_key: :origin_currency_id
    belongs_to :destination_currency, Currency, foreign_key: :destination_currency_id

    belongs_to :origin_account, User, foreign_key: :origin_account_id
    belongs_to :destination_account, User, foreign_key: :destination_account_id

    timestamps()
  end

  @required_fields [
    :timestamp,
    :amount,
    :type,
    :origin_currency,
    :destination_currency,
    :origin_account,
    :destination_account
  ]

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:type, Type.all())
    |> foreign_key_constraint(:origin_currency)
    |> foreign_key_constraint(:destination_currency)
    |> foreign_key_constraint(:origin_account)
    |> foreign_key_constraint(:destination_account)
  end
end
