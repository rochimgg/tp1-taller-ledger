defimpl Inspect, for: Ledger.Transactions.Transaction do
  import Ledger.Utils.InspectUtils

  def inspect(transaction, _opts) when transaction.type == :alta_cuenta do
    format_struct(transaction, [:created_at, :type, :amount, :origin_account_id, :origin_currency_id])
  end

    def inspect(transaction, _opts) when transaction.type == :swap do
    format_struct(transaction, [:created_at, :type, :amount, :origin_account_id, :origin_currency_id, :destination_currency_id])
  end

    def inspect(transaction, _opts) do
    format_struct(transaction, [:created_at, :type, :amount, :origin_account_id, :destination_account_id])
  end

end
