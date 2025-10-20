defmodule Ledger.CLI.Subcommands.SubcommandBehaviour do
  @callback get_all() :: list(map())
end
