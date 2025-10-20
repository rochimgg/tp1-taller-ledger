defmodule Ledger.CLI.Subcommands.UserSubcommandsTest do
  use ExUnit.Case, async: true
  import Mox

  alias Ledger.CLI.Subcommands.UserSubcommands
  alias Ledger.CLI.Options.UserOptionsMock

  setup :verify_on_exit!

  test "get_all llama a todas las funciones del módulo inyectado" do
    expect(UserOptionsMock, :create_user_options, fn -> [:mock_create_user] end)
    expect(UserOptionsMock, :update_user_options, fn -> [:mock_update_user] end)
    expect(UserOptionsMock, :delete_user_options, fn -> [:mock_delete_user] end)
    expect(UserOptionsMock, :get_user_options, fn -> [:mock_get_user] end)

    result = UserSubcommands.get_all(UserOptionsMock)

    # Comprobamos que existan todos los subcomandos
    assert Keyword.has_key?(result, :crear_usuario)
    assert Keyword.has_key?(result, :editar_usuario)
    assert Keyword.has_key?(result, :eliminar_usuario)
    assert Keyword.has_key?(result, :ver_usuario)

    # Comprobamos que cada subcomando tenga las opciones mockeadas
    assert result[:crear_usuario][:options] == [:mock_create_user]
    assert result[:editar_usuario][:options] == [:mock_update_user]
    assert result[:eliminar_usuario][:options] == [:mock_delete_user]
    assert result[:ver_usuario][:options] == [:mock_get_user]
  end
end
