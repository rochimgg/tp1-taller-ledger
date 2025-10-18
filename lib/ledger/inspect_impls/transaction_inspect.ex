defimpl Inspect, for: Ledger.Transactions.Transaction do
  import Ledger.Utils.InspectUtils

  def inspect(%{type: :alta_cuenta} = t, _opts) do
    format_struct(t, [
      :created_at,
      :type,
      :amount,
      :origin_account,
      :origin_currency
    ])
  end

  def inspect(%{type: :swap} = t, _opts) do
    format_struct(t, [
      :created_at,
      :type,
      :amount,
      :origin_account,
      :origin_currency,
      :destination_currency
    ])
  end

  def inspect(%{type: :transferencia} = t, _opts) do
    format_struct(t, [
      :created_at,
      :type,
      :amount,
      :origin_account,
      :destination_account,
      :origin_currency
    ])
  end

  def inspect(transaction, _opts) do
    format_struct(transaction, [
      :id,
      :type,
      :amount,
      :origin_account_id,
      :destination_account_id,
      :origin_currency_id,
      :destination_currency_id
    ])
  end
end
