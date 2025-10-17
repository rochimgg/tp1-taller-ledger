require Logger

defmodule Ledger.CLI.CurrencyUpdate do
  alias Ledger.Currencies.Currencies, as: CurrencyService

  def run(opts, currency_service \\ CurrencyService) do
    Logger.info("Ejecutando comando editar moneda con opciones: #{inspect(opts)}")
    case update_currency(opts, currency_service) do
      {:ok, currency} ->
        Logger.info(
          "Moneda actualizada exitosamente: #{inspect(currency)}"
        )

        {:ok, currency}

      {:error, reason} ->
        Logger.error("Error al actualizar moneda: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp update_currency(
         %{currency_id: id, usd_exchange_rate: usd_exchange_rate},
         currencies_module
       ) do
    currencies_module.update_currency(id, %{usd_exchange_rate: usd_exchange_rate})
  end
end
