defmodule GregslistWeb.UserListLive.Index do
  use GregslistWeb, :live_view
  alias Gregslist.Accounts

  def mount(_params, _session, socket) do
    users = Accounts.list_users()
    {:ok, assign(socket, users: users)}
  end
end
