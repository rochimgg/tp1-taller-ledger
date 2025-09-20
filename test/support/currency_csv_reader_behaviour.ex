defmodule Ledger.Currency.CSVReaderBehaviour do
  @callback stream!(path :: String.t()) :: Enumerable.t()
  @callback parse_line(line :: String.t()) :: map()
end
