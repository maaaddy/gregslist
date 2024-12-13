defmodule GregslistWeb.MessagesLive.Index do
  use GregslistWeb, :live_view
  import Gregslist.Messages

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns[:current_user]

    # Subscribe to the user's notification topic
    if user do
      topic = "messages:#{user.id}"
      Phoenix.PubSub.subscribe(Gregslist.PubSub, topic)
    end

    open_chats = if user && user.id, do: fetch_open_chats(user.id), else: []

    socket =
      socket
      |> assign(:current_user, user)
      |> assign(:open_chats, open_chats)
      |> assign(:new_message_notifications, %{}) # Track new message notifications

    {:ok, socket}
  end

  @impl true
  def handle_event("start_chat", %{"user_id" => user_id}, socket) do
    open_chats = socket.assigns.open_chats ++ [user_id] |> Enum.uniq()

    # Clear notifications for the opened chat
    new_notifications = Map.delete(socket.assigns.new_message_notifications, user_id)

    {:noreply, assign(socket, %{open_chats: open_chats, new_message_notifications: new_notifications})}
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    # Update notifications for the relevant chat
    new_notifications =
      Map.update(
        socket.assigns.new_message_notifications,
        message.sender_id,
        1,
        &(&1 + 1)
      )

    {:noreply, assign(socket, :new_message_notifications, new_notifications)}
  end
end
