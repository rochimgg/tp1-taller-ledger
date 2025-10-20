require Logger

defmodule Ledger.CLI.Currencies.CurrencyDelete do
  alias Ledger.Currencies.Currencies, as: CurrencyService

  def run(opts, currency_service \\ CurrencyService) do
    case delete_currency(opts, currency_service) do
      {:ok, currency} ->
        Logger.info("Moneda borrada exitosamente: #{inspect(currency)}")
        {:ok, currency}

      {:error, :not_found} ->
        Logger.error("No se encontró una moneda con ID #{inspect(opts.currency_id)}")
        {:error, :not_found}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp delete_currency(
         %{currency_id: id},
         currencies_module
       ) do
    currencies_module.delete(id)
  end

  defp delete_currency(_, _currencies_module) do
    Logger.error("Error: El ID de la moneda es obligatorio para eliminar.")
    {:error, :missing_currency_id}
  end
end
