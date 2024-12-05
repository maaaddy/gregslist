defmodule GregslistWeb.MessagesLive.Index do
  use GregslistWeb, :live_view
  alias Gregslist.Messages
  alias Gregslist.Accounts

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    conversations = Messages.list_user_conversations(user.id)
    {:ok, assign(socket, conversations: conversations, user: user)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>My Conversations</h1>
      <ul>
        <%= for conversation <- @conversations do %>
          <li>
            <a href={~p"/user_chat/#{get_recipient_id(conversation, @user)}"}>
              <%= get_other_user_name(conversation, @user) %>
            </a>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  defp get_other_user_name(conversation, user) do
    if conversation.sender_id == user.id do
      conversation.receiver_name
    else
      conversation.sender_name
    end
  end

  defp get_recipient_id(conversation, user) do
    if conversation.sender_id == user.id do
      conversation.receiver_id
    else
      conversation.sender_id
    end
  end
end
