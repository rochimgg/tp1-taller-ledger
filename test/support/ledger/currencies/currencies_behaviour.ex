defmodule Ledger.Currencies.CurrenciesBehaviour do
    @callback insert(map()) ::
              {:ok, any()}
              | {:error, Ecto.Changeset.t()}
              | {:error, String.t()}
              | {:error, atom()}
  @callback delete(integer()) :: {:ok, any()} | {:error, any()}
  @callback get_currency(integer()) :: {:ok, struct()} | {:error, :not_found}
    @callback update_currency(integer(), map()) ::
              {:ok, struct()} | {:error, Ecto.Changeset.t()} | {:error, term()}
end
