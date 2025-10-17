defmodule Ledger.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ledger.Transactions.Transaction

  schema "users" do
    field :username, :string
    field :birth_date, :date
    timestamps()

    has_many :sent_transactions, Transaction, foreign_key: :origin_account_id
    has_many :received_transactions, Transaction, foreign_key: :destination_account_id
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :birth_date])
    |> validate_required([:username, :birth_date])
    |> validate_username_unique()
    |> validate_age_over_18()
  end

  defp validate_age_over_18(changeset) do
    case get_field(changeset, :birth_date) do
      nil -> changeset
      birth_date ->
        today = Date.utc_today()
        age = Date.diff(today, birth_date) / 365.25
        if age < 18 do
          add_error(changeset, :birth_date, "El usuario debe ser mayor de 18 años")
        else
          changeset
        end
    end
  end

  defp validate_username_unique(changeset) do
    changeset
    |> unique_constraint(:username, message: "El nombre de usuario debe ser único")
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
