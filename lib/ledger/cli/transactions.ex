alias Ledger.Transactions.Service, as: Service

defmodule Ledger.CLI.Transactions do

  def run(opts) do
      Service.list_transactions(Service.load_from_csv_file(opts[:transaction_file_path]))
  end
end
