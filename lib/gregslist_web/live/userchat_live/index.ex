defmodule GregslistWeb.UserChatLive.Index do
  use GregslistWeb, :live_view
  import Ecto.Query
  alias Gregslist.Repo
  alias Gregslist.Messages.Message
  alias Gregslist.Accounts

  def mount(%{"recipient_id" => recipient_id}, _session, socket) do
    if connected?(socket) do
      GregslistWeb.Endpoint.subscribe(topic(recipient_id))
    end

    messages = load_messages(socket.assigns.current_user.id, recipient_id)

    {:ok, assign(socket, messages: messages, recipient_id: recipient_id, recipient_name: get_recipient_name(recipient_id))}
  end

  defp load_messages(current_user_id, recipient_id) do
    query =
      from m in Message,
      where: (m.sender_id == ^current_user_id and m.receiver_id == ^recipient_id) or
             (m.sender_id == ^recipient_id and m.receiver_id == ^current_user_id),
      order_by: [asc: m.timestamp]

    Repo.all(query)
  end

  def get_recipient_name(recipient_id) do
    case Accounts.get_user_by_id(recipient_id) do
      nil -> "Unknown User"
      user -> user.username
    end
  end

  def handle_info(%{event: "message", payload: message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  def handle_event("send", %{"text" => text}, socket) do
    current_user_id = socket.assigns.current_user.id
    recipient_id = socket.assigns.recipient_id

    %Message{}
    |> Message.changeset(%{
      content: text,
      sender_id: current_user_id,
      receiver_id: recipient_id,
      #At a later date I want to get the user's time zone w/ area code that they signed up w/. For now,
      #I'm keeping it at utc since it's the default.
      timestamp: DateTime.utc_now()
    })
    |> Repo.insert()

    GregslistWeb.Endpoint.broadcast(
      topic(recipient_id),
      "message",
      %{content: text, name: socket.assigns.current_user.username, sender_id: current_user_id, timestamp: DateTime.utc_now()}
    )

    {:noreply, socket}
  end

  def topic(recipient_id), do: "user_chat:#{recipient_id}"
end
