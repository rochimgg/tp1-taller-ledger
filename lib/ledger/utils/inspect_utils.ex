defmodule Ledger.Utils.InspectUtils do
  @moduledoc """
  Utilidades para formatear structs de dominio en logs e inspecciones.
  """

  def format_struct(struct, fields) do
    fields_str =
      fields
      |> Enum.map(fn field ->
        value = Map.get(struct, field)
        "#{field}=#{inspect(value)}"
      end)
      |> Enum.join(", ")

    module_name =
      struct.__struct__
      |> Module.split()
      |> List.last()

    "##{module_name}<#{fields_str}>"
  end

  def format_opts(opts) when is_map(opts) or is_list(opts) do
    opts
    |> Enum.map(fn {k, v} -> "#{k}=#{inspect(v)}" end)
    |> Enum.join(", ")
    |> then(&"{#{&1}}")
  end
end
