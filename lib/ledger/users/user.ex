defmodule Ledger.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ledger.Transactions.Transaction

  schema "users" do
    field :username, :string
    field :birthdate, :date
    timestamps()

    has_many :sent_transactions, Transaction, foreign_key: :origin_account_id
    has_many :received_transactions, Transaction, foreign_key: :destination_account_id
  end

    @type t :: %__MODULE__{
          id: integer(),
          username: String.t(),
          birthdate: Date.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :birthdate])
    |> validate_required([:username, :birthdate])
    |> unique_constraint(:username, name: :unique_username_index, message: "El nombre de usuario debe ser único")
    |> validate_birthdate()
    |> validate_age_over_18()
  end

  defp validate_age_over_18(changeset) do
    case get_field(changeset, :birthdate) do
      nil -> changeset
      birthdate ->
        today = Date.utc_today()
        age = Date.diff(today, birthdate) / 365.25
        if age < 18 do
          add_error(changeset, :birthdate, "El usuario debe ser mayor de 18 años")
        else
          changeset
        end
    end
  end


defp validate_birthdate(changeset) do
  case fetch_change(changeset, :birthdate) do
    {:ok, birthdate} ->
      cond do
        not is_struct(birthdate, Date) ->
          add_error(changeset, :birthdate, "Formato inválido. Debe ser YYYY-MM-DD")

        Date.compare(birthdate, Date.utc_today()) == :gt ->
          add_error(changeset, :birthdate, "La fecha de nacimiento no puede ser futura")

        Date.diff(Date.utc_today(), birthdate) < 365 * 18 ->
          add_error(changeset, :birthdate, "El usuario debe tener al menos 18 años")

        true ->
          changeset
      end

    :error ->
      changeset
  end
end

  def edit_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> validate_change(:username, fn :username, new_value ->
      if new_value == user.username do
        [username: "El nuevo nombre de usuario debe ser distinto al anterior"]
      else
        []
      end
    end)
  end
end
