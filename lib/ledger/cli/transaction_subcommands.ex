defmodule Ledger.CLI.TransactionSubcommands do

  alias Ledger.CLI.TransactionOptions, as: TransactionOptions

  def get_all do
    [
      create_account(),
      do_transfer(),
      do_swap(),
      undo_transaction(),
      get_transaction()
    ]
    |> Enum.flat_map(&Map.to_list/1)

  end

  defp create_account do
    %{
      alta_cuenta: [
        name: "alta_cuenta",
        about: "Dar de alta una nueva cuenta",
        options: TransactionOptions.create_account_options()
      ]
    }
  end

  defp do_transfer do
    %{
      realizar_transferencia: [
        name: "realizar_transferencia",
        about: "Realizar una transferencia entre cuentas",
        options: TransactionOptions.do_transfer_options()
      ]
    }
  end

  defp do_swap do
    %{
      realizar_swap: [
        name: "realizar_swap",
        about: "Realizar un swap entre monedas de un mismo usuario",
        options: TransactionOptions.do_swap_options()
      ]
    }
  end

  defp undo_transaction do
    %{
      deshacer_transaccion: [
        name: "deshacer_transaccion",
        about: "Deshacer una transacción realizada",
        options: TransactionOptions.undo_transaction_options()
      ]
    }
  end

    defp get_transaction do
    %{
      ver_transaccion: [
        name: "ver_transaccion",
        about: "Ver una transacción existente",
        options: TransactionOptions.get_transaction_options()
      ]
    }
  end
end
