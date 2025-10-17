defmodule Ledger.CLI.CurrencySubcommands do

  alias Ledger.CLI.CurrencyOptions, as: CurrencyOptions

  def get_all do
    [
      create_currency(),
      update_currency(),
      delete_currency(),
      get_currency()
    ]
    |> Enum.flat_map(&Map.to_list/1)
  end

  defp create_currency do
    %{
      crear_moneda: [
        name: "crear_moneda",
        about: "Crear una nueva moneda",
        options: CurrencyOptions.create_currency_options()
      ]
    }
  end

  defp update_currency do
    %{
      editar_moneda: [
        name: "editar_moneda",
        about: "Editar una moneda existente",
        options: CurrencyOptions.update_currency_options()
      ]
    }
  end

  defp delete_currency do
    %{
      eliminar_moneda: [
        name: "eliminar_moneda",
        about: "Eliminar una moneda existente",
        options: CurrencyOptions.delete_currency_options()
      ]
    }
  end

  defp get_currency do
    %{
      obtener_moneda: [
        name: "obtener_moneda",
        about: "Obtener una moneda existente",
        options: CurrencyOptions.get_currency_options()
      ]
    }
  end
end
