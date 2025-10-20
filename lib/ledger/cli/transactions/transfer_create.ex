require Logger

defmodule Ledger.CLI.Transactions.TransferCreate do
  alias Ledger.Transactions.Transactions, as: TransactionService

  def run(opts, transaction_service \\ TransactionService) do
    Logger.info("Ejecutando comando realizar transferencia con opciones: #{inspect(opts)}")
    create_transfer(opts, transaction_service)
  end

  defp create_transfer(%{origin_user_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id del usuario de origen es obligatorio.")
    {:error, :missing_origin_user_id}
  end

  defp create_transfer(%{destination_user_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id del usuario de destino es obligatorio.")
    {:error, :missing_destination_user_id}
  end

  defp create_transfer(%{currency_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id de la moneda es obligatorio.")
    {:error, :missing_currency_id}
  end

  defp create_transfer(%{amount: nil} = _opts, _transaction_service) do
    Logger.error("Error: El monto de la cuenta es obligatorio.")
    {:error, :missing_amount}
  end

  defp create_transfer(opts, _transaction_service) when opts.amount <= 0 do
    Logger.error("Error: El monto de la debe ser mayor a cero.")
    {:error, :amount_must_be_positive}
  end

defp create_transfer(opts, transaction_service) do
  case transaction_service.create_transfer(%{
         origin_user_id: opts.origin_user_id,
         destination_user_id: opts.destination_user_id,
         currency_id: opts.currency_id,
         amount: opts.amount
       }) do
    {:ok, transaction} ->
      Logger.info("Transferencia creada exitosamente: #{inspect(transaction)}")
      {:ok, transaction}

    {:error, %Ecto.Changeset{} = changeset} ->
      Enum.each(changeset.errors, fn {field, {message, _}} ->
        Logger.error("Error al crear la transferencia - #{field}: #{message}")
      end)
      {:error, changeset}

    {:error, msg} when is_binary(msg) ->
      Logger.error("Error al crear la transferencia: #{msg}")
      {:error, msg}

    other ->
      Logger.error("Error desconocido: #{inspect(other)}")
      {:error, :unknown}
  end
end

end
