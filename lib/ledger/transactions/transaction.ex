require Logger

defmodule Ledger.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ledger.Users.User, as: User
  alias Ledger.Currencies.Currency, as: Currency
  alias Ledger.Types.Type, as: Type

  schema "transactions" do
    field(:amount, :float)
    field(:type, Type)

    belongs_to(:origin_currency, Currency, foreign_key: :origin_currency_id)
    belongs_to(:destination_currency, Currency, foreign_key: :destination_currency_id)

    belongs_to(:origin_account, User, foreign_key: :origin_account_id)
    belongs_to(:destination_account, User, foreign_key: :destination_account_id)

    timestamps(updated_at: false)
  end

  def create_account_changeset(transaction, attrs) do
    transaction
    |> base_changeset(attrs)
    |> validate_required([:amount, :type, :origin_account_id, :origin_currency_id])
    |> put_change(:type, :alta_cuenta)
  end

  def create_transfer_changeset(transaction, attrs) do
    transaction
    |> base_changeset(attrs)
    |> validate_required([
      :amount,
      :type,
      :origin_account_id,
      :destination_account_id,
      :origin_currency_id
    ])
    |> put_change(:type, :transferencia)
  end

  def do_swap_changeset(transaction, attrs) do
    transaction
    |> base_changeset(attrs)
    |> validate_required([
      :amount,
      :type,
      :origin_account_id,
      :origin_currency_id,
      :destination_currency_id
    ])
    |> put_change(:type, :swap)
  end

  defp base_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :amount,
      :type,
      :origin_currency_id,
      :destination_currency_id,
      :origin_account_id,
      :destination_account_id
    ])
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:type, Type.all())
  end
end
