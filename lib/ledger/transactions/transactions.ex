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

  def undo_transaction(%{
        transaction_id: transaction_id
      }) do
    case get_transaction(transaction_id) do
      {:error, :not_found} -> {:error, :not_found}
      {:ok, transaction} -> undo_transaction_by_type(transaction)
    end
  end

  def get_transaction(id) when is_integer(id) do
    case Repo.get(Transaction, id) do
      nil -> {:error, :not_found}
      transaction -> {:ok, transaction}
    end
  end

  def get_transaction(id) when is_binary(id) do
    case Integer.parse(id) do
      {id, _} -> get_transaction(id)
      :error -> {:error, :invalid_id_format, "El ID debe ser un número entero."}
    end
  end

  defp undo_transaction_by_type(transaction) when transaction.type == :swap do
        %Transaction{}
    |> Transaction.create_swap_changeset(%{
      origin_account_id: transaction.origin_account_id,
      origin_currency_id: transaction.destination_currency_id,
      destination_currency_id: transaction.origin_currency_id,
      amount: transaction.amount,
      type: :swap
    })
    |> Repo.insert()
  end

    defp undo_transaction_by_type(transaction) when transaction.type == :transferencia do
        %Transaction{}
    |> Transaction.create_transfer_changeset(%{
      origin_account_id: transaction.destination_account_id,
      destination_account_id: transaction.origin_account_id,
      origin_currency_id: transaction.origin_currency_id,
      amount: transaction.amount,
      type: :transferencia
    })
    |> Repo.insert()
  end

end
