defmodule Ledger.CLI.Options.UserOptionsBehaviour do
  @callback create_user_options() :: list()
  @callback update_user_options() :: list()
  @callback delete_user_options() :: list()
  @callback get_user_options() :: list()
end
