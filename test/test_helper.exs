ExUnit.start()

Code.require_file("support/ledger/transactions_service_behaviour.ex", __DIR__)
Code.require_file("support/ledger/currency_service_behaviour.ex", __DIR__)
Code.require_file("support/ledger/currency_csv_reader_behaviour.ex", __DIR__)
Code.require_file("support/ledger/cli/options/currency_options_behaviour.ex", __DIR__)
Code.require_file("support/ledger/cli/options/tp1_options_behaviour.ex", __DIR__)
Code.require_file("support/ledger/cli/options/transaction_options_behaviour.ex", __DIR__)
Code.require_file("support/ledger/cli/options/user_options_behaviour.ex", __DIR__)
Code.require_file("support/ledger/cli/subcommands/subcommand_behaviour.ex", __DIR__)
Code.require_file("support/ledger/currencies/currencies_behaviour.ex", __DIR__)

Code.require_file("support/ledger/repo_behaviour.ex", __DIR__)






Mox.defmock(Ledger.Transactions.ServiceMock, for: Ledger.Transactions.ServiceBehaviour)
Mox.defmock(Ledger.Currency.ServiceMock, for: Ledger.Currency.ServiceBehaviour)
Mox.defmock(Ledger.Currency.CSVReaderMock, for: Ledger.Currency.CSVReaderBehaviour)

Mox.defmock(Ledger.CLI.Options.CurrencyOptionsMock,
  for: Ledger.CLI.Options.CurrencyOptionsBehaviour
)

Mox.defmock(Ledger.CLI.Options.Tp1OptionsMock,
  for: Ledger.CLI.Options.Tp1OptionsBehaviour
)

Mox.defmock(Ledger.CLI.Options.TransactionOptionsMock,
  for: Ledger.CLI.Options.TransactionOptionsBehaviour
)

Mox.defmock(Ledger.CLI.Options.UserOptionsMock,
  for: Ledger.CLI.Options.UserOptionsBehaviour
)


Mox.defmock(Ledger.CLI.Subcommands.CurrencySubcommandMock,
  for: Ledger.CLI.Subcommands.SubcommandBehaviour
)

Mox.defmock(Ledger.RepoMock,
  for: Ledger.RepoBehaviour
)

Mox.defmock(Ledger.Currencies.CurrenciesMock, for: Ledger.Currencies.CurrenciesBehaviour)
