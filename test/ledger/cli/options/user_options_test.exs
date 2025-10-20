defmodule Ledger.CLI.Options.UserOptionsTest do
  use ExUnit.Case, async: true

  alias Ledger.CLI.Options.UserOptions

  describe "create_user_options/0" do
    test "devuelve las opciones esperadas para crear usuario" do
      options = UserOptions.create_user_options()

      keys = Enum.map(options, &elem(&1, 0))
      assert :username in keys
      assert :birthdate in keys

      username_opt = Keyword.get(options, :username)
      assert username_opt[:required]
      assert username_opt[:long] == "--n"

      birthdate_opt = Keyword.get(options, :birthdate)
      assert birthdate_opt[:required]
      assert birthdate_opt[:long] == "--b"
    end
  end

  describe "update_user_options/0" do
    test "devuelve las opciones esperadas para actualizar usuario" do
      options = UserOptions.update_user_options()

      keys = Enum.map(options, &elem(&1, 0))
      assert :user_id in keys
      assert :username in keys

      user_id_opt = Keyword.get(options, :user_id)
      assert user_id_opt[:required]
      assert user_id_opt[:long] == "--id"

      username_opt = Keyword.get(options, :username)
      assert username_opt[:required]
      assert username_opt[:long] == "--n"
    end
  end

  describe "delete_user_options/0" do
    test "devuelve las opciones esperadas para borrar usuario" do
      options = UserOptions.delete_user_options()

      assert Enum.map(options, &elem(&1, 0)) == [:user_id]

      user_id_opt = Keyword.get(options, :user_id)
      assert user_id_opt[:required]
      assert user_id_opt[:help] =~ "Id del usuario"
    end
  end

  describe "get_user_options/0" do
    test "devuelve las opciones esperadas para obtener usuario" do
      options = UserOptions.get_user_options()

      assert Enum.map(options, &elem(&1, 0)) == [:user_id]
      user_id_opt = Keyword.get(options, :user_id)

      assert user_id_opt[:required]
      assert user_id_opt[:long] == "--id"
      assert user_id_opt[:value_name] == "ID_USUARIO"
    end
  end
end
