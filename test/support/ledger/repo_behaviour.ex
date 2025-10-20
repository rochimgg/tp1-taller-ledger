defmodule Ledger.RepoBehaviour do
  @callback all(module()) :: list()
  @callback get(module(), any()) :: any()
  @callback insert(Ecto.Changeset.t()) :: {:ok, any()} | {:error, any()}
  @callback update(Ecto.Changeset.t()) :: {:ok, any()} | {:error, any()}
  @callback delete(any()) :: {:ok, any()} | {:error, any()}
end
