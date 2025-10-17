require Logger

defmodule Ledger.CLI.SwapCreate do
  alias Ledger.Transactions.Transactions, as: TransactionService

  def run(opts, transaction_service \\ TransactionService) do
    Logger.info("Ejecutando comando realizar swap con opciones: #{inspect(opts)}")
    create_swap(opts, transaction_service)
  end

  defp create_swap(%{user_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id del usuario de origen es obligatorio.")
    {:error, :missing_origin_user_id}
  end

  defp create_swap(%{origin_currency_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id de la moneda de origen es obligatorio.")
    {:error, :missing_origin_currency_id}
  end

  defp create_swap(%{destination_currency_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id de la moneda de destino es obligatorio.")
    {:error, :missing_destination_currency_id}
  end

  defp create_swap(%{amount: nil} = _opts, _transaction_service) do
    Logger.error("Error: El monto de la cuenta es obligatorio.")
    {:error, :missing_amount}
  end

  defp create_swap(opts, _transaction_service) when opts.amount <= 0 do
    Logger.error("Error: El monto de la debe ser mayor a cero.")
    {:error, :amount_must_be_positive}
  end

  defp create_swap(opts, transaction_service) do
    case transaction_service.create_swap(%{
           origin_account_id: opts.user_id,
           origin_currency_id: opts.origin_currency_id,
           destination_currency_id: opts.destination_currency_id,
           amount: opts.amount
         }) do
      {:ok, transaction} ->
        Logger.info("Swap creado exitosamente: #{inspect(transaction)}")
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
