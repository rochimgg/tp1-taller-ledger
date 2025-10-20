defmodule Ledger.CLI.Subcommands.CurrencySubcommands do
  alias Ledger.CLI.Options.CurrencyOptions, as: CurrencyOptions

  def get_all(options_module \\ CurrencyOptions) do
    [
      create_currency(options_module),
      update_currency(options_module),
      delete_currency(options_module),
      get_currency(options_module)
    ]
    |> Enum.flat_map(&Map.to_list/1)
  end

  defp create_currency(options_module) do
    %{
      crear_moneda: [
        name: "crear_moneda",
        about: "Crear una nueva moneda",
        options: options_module.create_currency_options()
      ]
    }
  end

  defp update_currency(options_module) do
    %{
      editar_moneda: [
        name: "editar_moneda",
        about: "Editar una moneda existente",
        options: options_module.update_currency_options()
      ]
    }
  end

  defp delete_currency(options_module) do
    %{
      borrar_moneda: [
        name: "borrar_moneda",
        about: "Eliminar una moneda existente",
        options: options_module.delete_currency_options()
      ]
    }
  end

  defp get_currency(options_module) do
    %{
      ver_moneda: [
        name: "ver_moneda",
        about: "Obtener una moneda existente",
        options: options_module.get_currency_options()
      ]
    }
  end
end
