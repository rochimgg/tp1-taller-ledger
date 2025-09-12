defmodule Ledger.Services.FileOperations do
  alias CSV


  def leer_csv(file_path) do
    file_path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.to_list()
  end

  def excribir_csv(file_path, rows) do
    rows
    |> Enum.map(fn
      %_{} = struct -> Map.from_struct(struct)
      map when is_map(map) -> map
    end)
    |> CSV.encode(headers: true)
    |> Enum.into(File.stream!(file_path))
  end
end
