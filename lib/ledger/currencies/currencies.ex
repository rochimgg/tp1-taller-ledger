require Logger

defmodule Ledger.Currencies.Currencies do
  require Logger
  alias Ledger.Currencies.Currency, as: Currency
  alias Ledger.Repo, as: Repo

  def get_all do
    Repo.all(Currency)
  end

  def update(currency_id, attrs) do
    case Repo.get(Currency, currency_id) do
      nil ->
        {:error, :not_found}

      currency ->
        currency
        |> Currency.changeset(attrs)
        |> Repo.update()
    end
  end

  def get_by_id(id) when is_integer(id) do
    case Repo.get(Currency, id) do
      nil -> {:error, :not_found}
      currency -> {:ok, currency}
    end
  end

  def delete_by_id(id) do
    case Repo.get(Currency, id) do
      nil -> {:error, :not_found}
      currency -> Repo.delete(currency)
    end
  end

  def insert(attrs) do
    Logger.debug("Atributos recibidos en create_currency: #{inspect(attrs)}")

    case Map.fetch(attrs, :usd_exchange_rate) do
      {:ok, value} ->
        case parse_float(value) do
          {:ok, float_val} ->
            %Currency{}
            |> Currency.changeset(Map.put(attrs, :usd_exchange_rate, float_val))
            |> Repo.insert()

          {:error, msg} ->
            Logger.error("No se pudo parsear usd_exchange_rate: #{msg}")
            {:error, "No se pudo convertir '#{value}' a float"}
        end

      :error ->
        %Currency{}
        |> Currency.changeset(attrs)
        |> Repo.insert()
    end
  end

  defp parse_float({:ok, value}) when is_float(value), do: {:ok, value}

  defp parse_float(value) when is_binary(value) do
    clean_value = String.trim(value)
    Logger.debug("Parseando valor a float: #{inspect(clean_value)}")

    case Float.parse(clean_value) do
      {num, ""} ->
        {:ok, num}

      {_num, rest} ->
        {:error, "No es un número válido (sobrante: #{inspect(rest)})"}

      :error ->
        {:error, "No es un número válido: #{inspect(value)}"}
    end
  end

  defp parse_float(value) when is_integer(value) do
    Logger.debug("Parseando entero a float: #{inspect(value)}")
    {:ok, value * 1.0}
  end

  defp parse_float(value) when is_float(value) do
    Logger.debug("Valor ya es float: #{inspect(value)}")
    {:ok, value}
  end

  defp parse_float(_value) do
    {:error, "Tipo no válido para conversión a float"}
  end
end
