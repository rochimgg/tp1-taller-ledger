defmodule Ledger.Types.Type do
  @alta_cuenta :alta_cuenta
  @swap :swap
  @transferencia :transferencia

  @type type :: :alta_cuenta | :swap | :transferencia

  def alta_cuenta, do: @alta_cuenta
  def swap, do: @swap
  def transferencia, do: @transferencia

  def all, do: [@alta_cuenta, @swap, @transferencia]

  @string_map %{
    "alta_cuenta" => @alta_cuenta,
    "swap" => @swap,
    "transferencia" => @transferencia
  }

  def from_string(str) when is_binary(str) do
    Map.fetch!(@string_map, str)
  end
  
end
