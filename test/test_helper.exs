ExUnit.start()

Code.require_file("support/transactions_service_behaviour.ex", __DIR__)
Code.require_file("support/currency_service_behaviour.ex", __DIR__)
Code.require_file("support/currency_csv_reader_behaviour.ex", __DIR__)

Mox.defmock(Ledger.Transactions.ServiceMock, for: Ledger.Transactions.ServiceBehaviour)
Mox.defmock(Ledger.Currency.ServiceMock, for: Ledger.Currency.ServiceBehaviour)
Mox.defmock(Ledger.Currency.CSVReaderMock, for: Ledger.Currency.CSVReaderBehaviour)
