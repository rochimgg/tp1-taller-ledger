

defmodule Ledger.CLI.Transactions.BalanceGet do
  alias Ledger.Types.Type, as: TransactionType
  alias Ledger.Schemas.Balance, as: Balance
  alias Ledger.Transactions.Service, as: TransactionService
  alias Ledger.Currency.Service, as: CurrencyService

def run(opts, transaction_service \\ TransactionService, currency_service \\ CurrencyService) do
    IO.inspect(opts, label: "Ejecutando comando balance con opciones")
    transaction_service.load_from_csv_file(opts[:transaction_file_path])
    |> process_balance(opts, currency_service)
    |> tap(fn _ -> IO.puts("MONEDA=BALANCE") end)
    |> print_balances()
  end

  defp process_balance({:ok, transactions}, opts, currency_service) do
    do_process(transactions, opts, currency_service)
  end

  defp process_balance({:error, reason}, _opts, _currency_service), do: {:error, reason}

  defp do_process(transactions, %{currency: nil} = opts, currency_service) do
    currency_rates = currency_service.currency_lookup()

    balances =
      Enum.map(currency_rates, fn {currency, rate} ->
        incomes =
          transactions
          |> Enum.filter(fn tx ->
            Map.get(tx, :destination_account) == opts.origin_account and
              tx.destination_currency == currency and
              tx.type != TransactionType.swap()
          end)
          |> Enum.reduce(0, fn tx, acc -> acc + tx.amount end)

        outcomes =
          transactions
          |> Enum.filter(fn tx ->
            tx.origin_account == opts.origin_account and
              tx.origin_currency == currency and
              tx.type != TransactionType.swap()
          end)
          |> Enum.reduce(0, fn tx, acc -> acc + tx.amount end)

        amount = (incomes - outcomes) * rate
        cs = Balance.changeset(%Balance{}, %{currency_name: currency, amount: amount})

        if cs.valid? do
          Ecto.Changeset.apply_changes(cs)
        else
          IO.inspect({:error, "Invalid balance for currency #{currency}"})
          System.halt(1)
        end
      end)
      |> Enum.filter(fn %Balance{amount: amount} -> amount != 0 end)

    {:ok, balances}
  end

  defp do_process(transactions, %{currency: currency} = opts, currency_service) do
    currency_rates = currency_service.currency_lookup()

    case Map.fetch(currency_rates, currency) do
      {:ok, rate} ->
        incomes =
          transactions
          |> Enum.filter(fn tx ->
            Map.get(tx, :destination_account) == opts.origin_account and
              tx.type != TransactionType.swap()
          end)
          |> Enum.reduce(0, fn tx, acc -> acc + tx.amount end)

        outcomes =
          transactions
          |> Enum.filter(fn tx ->
            tx.origin_account == opts.origin_account and
              tx.type != TransactionType.swap()
          end)
          |> Enum.reduce(0, fn tx, acc -> acc + tx.amount end)

        amount = (incomes - outcomes) * rate
        cs = Balance.changeset(%Balance{}, %{currency_name: currency, amount: amount})

        if cs.valid? do
          {:ok, [Ecto.Changeset.apply_changes(cs)]}
        else
          IO.inspect({:error, "Invalid balance for currency #{currency}"})
          System.halt(1)
        end

      :error ->
        # Moneda pasada por parámetro no válida
        IO.inspect({:error, 1})
        System.halt(1)
    end
  end

  def print_balances({:ok, balances}) do
    Enum.each(balances, fn %Balance{currency_name: currency, amount: amount} ->
      :io.format("~s=~.6f~n", [currency, amount])
    end)
  end

  def print_balances({:error, reason}) do
    IO.inspect({:error, reason})
    System.halt(1)
  end
end
