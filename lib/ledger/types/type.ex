defmodule Ledger.Types.Type do
  @behaviour Ecto.Type

  @alta_cuenta :alta_cuenta
  @swap :swap
  @transferencia :transferencia

  @type t :: :alta_cuenta | :swap | :transferencia

  @string_map %{
    "alta_cuenta" => @alta_cuenta,
    "swap" => @swap,
    "transferencia" => @transferencia
  }

  @impl true
  def type, do: :string

  @impl true
  def cast(value) when is_atom(value) do
    if value in Map.values(@string_map), do: {:ok, value}, else: :error
  end
  def cast(value) when is_binary(value), do: from_string(value)
  def cast(_), do: :error

  @impl true
  def load(value) when is_binary(value), do: from_string(value)
  def load(_), do: :error

  @impl true
  def dump(value) when is_atom(value) do
    if value in Map.values(@string_map), do: {:ok, to_string(value)}, else: :error
  end
  def dump(_), do: :error

  @impl true
  def embed_as(_format), do: :self

  @impl true
  def equal?(a, b), do: a == b

  def alta_cuenta, do: @alta_cuenta
  def swap, do: @swap
  def transferencia, do: @transferencia

  def all, do: Map.values(@string_map)

  def from_string(str) when is_binary(str) do
    case Map.fetch(@string_map, str) do
      {:ok, atom} -> {:ok, atom}
      :error -> :error
    end
  end
end
