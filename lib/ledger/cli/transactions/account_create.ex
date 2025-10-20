require Logger

defmodule Ledger.CLI.Transactions.AccountCreate do
  alias Ledger.Transactions.Transactions, as: TransactionService

  def run(opts, transaction_service \\ TransactionService) do
    Logger.info("Ejecutando comando alta cuenta con opciones: #{inspect(opts)}")
    create_account(opts, transaction_service)
  end

  defp create_account(%{user_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id del usuario es obligatorio.")
    {:error, :missing_user_id}
  end

  defp create_account(%{currency_id: nil} = _opts, _transaction_service) do
    Logger.error("Error: El id de la moneda es obligatorio.")
    {:error, :missing_currency_id}
  end

  defp create_account(%{amount: nil} = _opts, _transaction_service) do
    Logger.error("Error: El monto de la cuenta es obligatorio.")
    {:error, :missing_amount}
  end

  defp create_account(opts, _transaction_service) when opts.amount <= 0 do
    Logger.error("Error: El monto de la debe ser mayor a cero.")
    {:error, :amount_must_be_positive}
  end

defp create_account(opts, transaction_service) do
  case transaction_service.create_account(%{
         user_id: opts.user_id,
         currency_id: opts.currency_id,
         amount: opts.amount
       }) do
    {:ok, transaction} ->
      Logger.info("Cuenta creada exitosamente: #{inspect(transaction)}")
      {:ok, transaction}

    {:error, %Ecto.Changeset{} = changeset} ->
      Enum.each(changeset.errors, fn {field, {message, _}} ->
        Logger.error("Error al crear la cuenta - #{field}: #{message}")
      end)
      {:error, changeset}

    {:error, msg} when is_binary(msg) ->
      Logger.error("Error al crear la cuenta: #{msg}")
      {:error, msg}

    other ->
      Logger.error("Error desconocido: #{inspect(other)}")
      {:error, :unknown}
  end
end

end
