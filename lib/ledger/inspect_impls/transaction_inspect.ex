defimpl Inspect, for: Ledger.Transactions.Transaction do
  import Ledger.Utils.InspectUtils

  def inspect(transaction, _opts) do
    format_struct(transaction, [:timestamp, :type])
  end
end
