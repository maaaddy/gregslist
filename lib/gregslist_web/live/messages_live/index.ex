defmodule GregslistWeb.MessagesLive.Index do
  use GregslistWeb, :live_view
  import Gregslist.Messages

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns[:current_user]

    # Fetch open chats usernames instead of user IDs
    open_chats = if user && user.id, do: fetch_open_chats(user.id), else: []

    socket =
      socket
      |> assign(:current_user, user)
      |> assign(:open_chats, open_chats)

    {:ok, socket}
  end

  @impl true
  def handle_event("start_chat", %{"user_id" => user_id}, socket) do
    open_chats = socket.assigns.open_chats ++ [user_id] |> Enum.uniq()
    {:noreply, assign(socket, :open_chats, open_chats)}
  end
end
