require Logger

defmodule Ledger.CLI.Transactions.UndoTransactionCreate do
  alias Ledger.Transactions.Transactions, as: TransactionService

  def run(opts, transaction_service \\ TransactionService) do
    Logger.info("Ejecutando comando deshacer transaccion con opciones: #{inspect(opts)}")
    undo_transaction(opts, transaction_service)
  end

  defp undo_transaction(%{user_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id del usuario de origen es obligatorio.")
    {:error, :missing_origin_user_id}
  end

  defp undo_transaction(%{origin_currency_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id de la moneda de origen es obligatorio.")
    {:error, :missing_origin_currency_id}
  end

  defp undo_transaction(%{destination_currency_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id de la moneda de destino es obligatorio.")
    {:error, :missing_destination_currency_id}
  end

  defp undo_transaction(%{amount: nil} = _opts, _transaction_service) do
    Logger.error("Error: El monto de la cuenta es obligatorio.")
    {:error, :missing_amount}
  end

  defp undo_transaction(opts, _transaction_service) when opts.amount <= 0 do
    Logger.error("Error: El monto de la debe ser mayor a cero.")
    {:error, :amount_must_be_positive}
  end

  defp undo_transaction(opts, transaction_service) do
    case transaction_service.undo_transaction(%{
           transaction_id: opts.transaction_id
         }) do
      {:ok, transaction} ->
        Logger.info("Transaccion deshecha exitosamente: #{inspect(transaction)}")
        {:ok, transaction}

      {:error, %Ecto.Changeset{} = changeset} ->
        Enum.each(changeset.errors, fn {field, {message, _}} ->
          Logger.error("Error al crear el swap - #{field}: #{message}")
        end)

        {:error, changeset}

      {:error, msg} when is_binary(msg) ->
        Logger.error("Error al crear el swap: #{msg}")
        {:error, msg}

      other ->
        Logger.error("Error desconocido: #{inspect(other)}")
        {:error, :unknown}
    end
  end
end
