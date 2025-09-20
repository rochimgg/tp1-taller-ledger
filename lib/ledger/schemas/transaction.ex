alias Ledger.Types.Type, as: Type
alias Ledger.Currency.Service, as: CurrencyService

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
    currency_lookup = CurrencyService.currency_lookup()

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
    |> validate_currency_inclusion(:origin_currency, currency_lookup)
    |> validate_currency_inclusion(:destination_currency, currency_lookup)
    |> validate_accounts_for_transfer()
  end

  defp validate_currency_inclusion(changeset, field, currency_lookup) do
    validate_change(changeset, field, fn _, value ->
      if value == nil or Map.has_key?(currency_lookup, value) do
        []
      else
        [{field, "is not a valid currency"}]
      end
    end)
  end

  defp validate_accounts_for_transfer(changeset) do
    if get_field(changeset, :type) == :transferencia do
      changeset
      |> validate_required([:origin_account, :destination_account])
      |> validate_change(:destination_account, fn _, destination_account ->
        origin_account = get_field(changeset, :origin_account)

        if destination_account == origin_account do
          [destination_account: "cannot be the same as origin_account"]
        else
          []
        end
      end)
    else
      changeset
    end
  end
end
