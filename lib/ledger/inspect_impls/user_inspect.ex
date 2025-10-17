defimpl Inspect, for: Ledger.Users.User do
  import Ledger.Utils.InspectUtils

  def inspect(user, _opts) do
    format_struct(user, [:username, :birthdate])
  end
end
