defmodule Ledger.Currencies.Currencies do
  require Logger
  alias Ledger.Currencies.Currency
  alias Ledger.Repo, as: Repo

  def get_all(repo \\ Repo) do
    repo.all(Currency)
  end

  def get(id, repo \\ Repo) when is_integer(id) do
    case repo.get(Currency, id) do
      nil -> {:error, :not_found}
      currency -> {:ok, currency}
    end
  end

  def insert(attrs, repo \\ Repo) do
    Logger.debug("Atributos recibidos en create_currency: #{inspect(attrs)}")

    case Map.fetch(attrs, :usd_exchange_rate) do
      {:ok, value} ->
        case parse_float(value) do
          {:ok, float_val} ->
            %Currency{}
            |> Currency.changeset(Map.put(attrs, :usd_exchange_rate, float_val))
            |> repo.insert()

          {:error, msg} ->
            Logger.error("No se pudo parsear usd_exchange_rate: #{msg}")
            {:error, "No se pudo convertir '#{value}' a float"}
        end

      :error ->
        %Currency{}
        |> Currency.changeset(attrs)
        |> repo.insert()
    end
  end

  def update(currency_id, attrs, repo \\ Repo) do
    case repo.get(Currency, currency_id) do
      nil ->
        {:error, :not_found}

      currency ->
        case currency
        |> Currency.changeset(attrs)
        |> repo.update() do
          {:ok, _currency} -> {:ok, :updated_currency}
          {:error, _changeset} -> {:error, :update_error}
        end
    end
  end

  def delete(id, repo \\ Repo) do
    case repo.get(Currency, id) do
      nil -> {:error, :not_found}
      currency -> repo.delete(currency)
        {:ok, :deleted}
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
