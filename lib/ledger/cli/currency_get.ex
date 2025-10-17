require Logger

defmodule Ledger.CLI.CurrencyGet do
  alias Ledger.Currencies.Currencies, as: CurrencyService

  @spec run(%{:currency_id => nil | binary() | integer(), optional(any()) => any()}) ::
          {:ok, any()}
          | {:error, :invalid_id_format | :missing_id | :not_found, <<_::64, _::_*8>>}
  def run(opts, currency_service \\ CurrencyService) do
    Logger.info("Ejecutando comando obtener moneda con opciones: #{inspect(opts)}")
    get_currency(opts, currency_service)
  end

  defp get_currency(%{currency_id: nil}, _currency_service) do
    {:error, :missing_id, "Debe especificarse un ID de moneda."}
  end

  defp get_currency(%{currency_id: id_str}, currency_service) when is_binary(id_str) do
    case Integer.parse(id_str) do
      {id, _} -> get_currency(%{currency_id: id}, currency_service)
      :error -> {:error, :invalid_id_format, "El ID debe ser un número entero."}
    end
  end

  defp get_currency(%{currency_id: id}, currency_service) when is_integer(id) do
    case currency_service.get_currency(id) do
      {:ok, currency} ->
        Logger.info("Moneda encontrada: #{inspect(currency)}")
        {:ok, currency}

      {:error, :not_found} ->
        Logger.error("No se encontró una moneda con ID #{id}")
        {:error, :not_found, "No se encontró una moneda con ID #{id}"}
    end
  end
end
