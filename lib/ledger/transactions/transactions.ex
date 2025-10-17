defmodule Ledger.Transactions.Transactions do
  alias Ledger.Transactions.Transaction, as: Transaction
  alias Ledger.Repo, as: Repo

  def create_account(%{user_id: user_id, currency_id: currency_id, amount: amount}) do
    %Transaction{}
    |> Transaction.create_account_changeset(%{
      origin_account_id: user_id,
      origin_currency_id: currency_id,
      amount: amount,
      type: :alta_cuenta
    })
    |> Repo.insert()
  end

  def create_transfer(%{
        origin_user_id: origin_user_id,
        destination_user_id: destination_user_id,
        currency_id: currency_id,
        amount: amount
      }) do
    %Transaction{}
    |> Transaction.create_transfer_changeset(%{
      origin_account_id: origin_user_id,
      destination_account_id: destination_user_id,
      origin_currency_id: currency_id,
      amount: amount,
      type: :transferencia
    })
    |> Repo.insert()
  end

  def create_swap(%{
        origin_account_id: user_id,
        origin_currency_id: origin_currency_id,
        destination_currency_id: destination_currency_id,
        amount: amount
      }) do
    %Transaction{}
    |> Transaction.create_swap_changeset(%{
      origin_account_id: user_id,
      origin_currency_id: origin_currency_id,
      destination_currency_id: destination_currency_id,
      amount: amount,
      type: :swap
    })
    |> Repo.insert()
  end

  def get_user(id) when is_integer(id) do
    case Repo.get(Transaction, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
