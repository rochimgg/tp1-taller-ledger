defmodule Ledger do
  def main(argv \\ System.argv()) do
    IO.inspect(argv, label: "Args originales")
    argv
    |> Ledger.CLI.normalize_custom_flags()
    |> IO.inspect(label: "Args normalizados")
    |> (fn args -> Optimus.parse!(Ledger.CLI.optimus(), args) end).()
    |> handle_parsed_args()
  end

  defp handle_parsed_args(parsed) do
    IO.inspect(parsed, label: "Parsed args")
    # despachar subcommands u opciones
  end

end
