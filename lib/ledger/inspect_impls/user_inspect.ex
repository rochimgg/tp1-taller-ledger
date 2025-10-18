defimpl Inspect, for: Ledger.Users.User do
  import Ledger.Utils.InspectUtils

  def inspect(user, _opts) do
    format_struct(user, [:id, :username, :birthdate])
  end
end
