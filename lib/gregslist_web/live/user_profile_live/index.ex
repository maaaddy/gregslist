defmodule GregslistWeb.UserProfileLive.Index do
  use GregslistWeb, :live_view
  
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    {:ok, assign(socket, user: user)}
  end
end
