
alias Ledger.Transactions.Service, as: TransactionService
alias Ledger.Currency.Service, as: CurrencyService

defmodule Ledger.CLI.Balance do
  def run(opts) do
    IO.inspect(opts, label: "Ejecutando comando balance")
    TransactionService.load_from_csv_file(opts[:transaction_file_path])
    |> TransactionService.list_transactions()
    |> IO.inspect(label: "Transacciones")

    currency(opts)
  end

  def currency(opts) do
    IO.inspect(opts, label: "Ejecutando comando balance")
    CurrencyService.load_from_csv_file(Path.join(:code.priv_dir(:ledger), "data/moneda.csv"))
    |> IO.inspect(label: "Currencies loaded")
    |> CurrencyService.list_currencies()
    |> IO.inspect(label: "Currencies")
  end

end
