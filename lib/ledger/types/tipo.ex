defmodule Tipo do
  @alta_cuenta :alta_cuenta
  @swap :swap
  @transferencia :transferencia

  @type tipo :: :alta_cuenta | :swap | :transferencia

  def alta_cuenta, do: @alta_cuenta
  def swap, do: @swap
  def transferencia, do: @transferencia

  def all, do: [@alta_cuenta, @swap, @transferencia]
end
