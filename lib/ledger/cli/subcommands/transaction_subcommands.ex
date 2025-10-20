defmodule Ledger.CLI.Subcommands.TransactionSubcommands do
  alias Ledger.CLI.Options.TransactionOptions

  def get_all(options_module \\ TransactionOptions) do
    [
      create_account(options_module),
      do_transfer(options_module),
      do_swap(options_module),
      undo_transaction(options_module),
      get_transaction(options_module)
    ]
    |> Enum.flat_map(&Map.to_list/1)
  end

  defp create_account(options_module) do
    %{
      alta_cuenta: [
        name: "alta_cuenta",
        about: "Dar de alta una nueva cuenta",
        options: options_module.create_account_options()
      ]
    }
  end

  defp do_transfer(options_module) do
    %{
      realizar_transferencia: [
        name: "realizar_transferencia",
        about: "Realizar una transferencia entre cuentas",
        options: options_module.do_transfer_options()
      ]
    }
  end

  defp do_swap(options_module) do
    %{
      realizar_swap: [
        name: "realizar_swap",
        about: "Realizar un swap entre monedas de un mismo usuario",
        options: options_module.do_swap_options()
      ]
    }
  end

  defp undo_transaction(options_module) do
    %{
      deshacer_transaccion: [
        name: "deshacer_transaccion",
        about: "Deshacer una transacción realizada",
        options: options_module.undo_transaction_options()
      ]
    }
  end

  defp get_transaction(options_module) do
    %{
      ver_transaccion: [
        name: "ver_transaccion",
        about: "Ver una transacción existente",
        options: options_module.get_transaction_options()
      ]
    }
  end
end
