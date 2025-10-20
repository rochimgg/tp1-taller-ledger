defmodule MockReader do
  def stream!(_), do: [
    "",   # empty line to skip
    #"8;1759775404;EUR;BTC;0.05;userC;userB;transferencia"
  ]

  def parse_line(line), do: Ledger.Transactions.CSVReader.parse_line(line)
end
