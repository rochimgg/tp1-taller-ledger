require Logger

defmodule Ledger.CLI.CurrencyDelete do
  alias Ledger.Currencies.Currencies, as: CurrencyService

  def run(opts, currency_service \\ CurrencyService) do
    case delete_currency(opts, currency_service) do
      {:ok, currency} ->
        Logger.info("Moneda borrada exitosamente: #{inspect(currency)}")
        {:ok, currency}

      {:error, :not_found} ->
        Logger.error("No se encontró una moneda con ID #{inspect(opts.currency_id)}")
        {:error, "No se encontró una moneda con ID #{inspect(opts.currency_id)}"}
    end
  end

  defp delete_currency(
         %{currency_id: id},
         currencies_module
       ) do
    currencies_module.delete_currency(id)
  end
end
