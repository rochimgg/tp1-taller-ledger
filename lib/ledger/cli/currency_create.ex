require Logger

defmodule Ledger.CLI.CurrencyCreate do
  alias Ledger.Currencies.Currencies, as: CurrencyService
  @spec run(any(), any()) :: {:error, any()} | {:ok, any()}
  def run(opts, currency_service \\ CurrencyService) do
    Logger.info("Ejecutando comando crear moneda con opciones: #{inspect(opts)}")
    create_currency(opts, currency_service)
  end

  defp create_currency(%{currency_name: nil} = _opts, _currency_service) do
    Logger.error("Error: El nombre de la moneda es obligatorio.")
    {:error, :missing_currency_name}
  end

  defp create_currency(%{usd_exchange_rate: nil} = _opts, _currency_service) do
    Logger.error("Error: La tasa de cambio USD es obligatoria.")
    {:error, :missing_usd_exchange_rate}
  end

defp create_currency(opts, currency_service) do
  case currency_service.create_currency(%{
         currency_name: opts.currency_name,
         usd_exchange_rate: opts.usd_exchange_rate
       }) do
    {:ok, currency} ->
      Logger.info("Moneda creada exitosamente: #{inspect(currency)}")
      {:ok, currency}

    {:error, %Ecto.Changeset{} = changeset} ->
      Enum.each(changeset.errors, fn {field, {message, _}} ->
        Logger.error("Error al crear la moneda - #{field}: #{message}")
      end)
      {:error, changeset}

    {:error, msg} when is_binary(msg) ->
      Logger.error("Error al crear la moneda: #{msg}")
      {:error, msg}

    other ->
      Logger.error("Error desconocido: #{inspect(other)}")
      {:error, :unknown}
  end
end

end
