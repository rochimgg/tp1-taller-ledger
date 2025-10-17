defimpl Inspect, for: Ledger.Currencies.Currency do
  import Ledger.Utils.InspectUtils

  def inspect(currency, _opts) do
    format_struct(currency, [:id, :currency_name, :usd_exchange_rate])
  end
end
