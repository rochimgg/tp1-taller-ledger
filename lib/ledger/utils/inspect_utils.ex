defmodule Ledger.Utils.InspectUtils do
  def format_struct(struct, fields \\ []) do
    name =
      struct.__struct__
      |> Module.split()
      |> List.last()

    struct
    |> Map.from_struct()
    |> Map.drop([:__meta__])
    |> maybe_take(fields)
    |> Enum.map(fn {k, v} -> "#{k}: #{safe_inspect(v)}" end)
    |> Enum.join(", ")
    |> then(&"##{name}{#{&1}}")
  end

  defp maybe_take(map, []), do: map
  defp maybe_take(map, fields), do: Map.take(map, fields)

  defp safe_inspect(%Ecto.Association.NotLoaded{} = not_loaded) do
    field = Map.get(not_loaded, :field) || "unknown"
    "#Ecto.Association.NotLoaded<#{field}>"
  end

  defp safe_inspect(%{__struct__: _} = struct) do
    # intenta usar inspect normal para structs cargadas
    try do
      inspect(struct)
    rescue
      _ -> "#<uninspectable #{inspect(struct.__struct__)}>"
    end
  end

  defp safe_inspect({a, b}) do
    "{#{safe_inspect(a)}, #{safe_inspect(b)}}"
  end

  defp safe_inspect(list) when is_list(list) do
    "[" <> Enum.map_join(list, ", ", &safe_inspect/1) <> "]"
  end

  defp safe_inspect(map) when is_map(map) do
    map
    |> Enum.map(fn {k, v} -> "#{safe_inspect(k)}: #{safe_inspect(v)}" end)
    |> Enum.join(", ")
    |> then(&"%{#{&1}}")
  end

  defp safe_inspect(value) do
    try do
      inspect(value)
    rescue
      _ -> "#<uninspectable #{inspect(value)}>"
    end
  end
end
