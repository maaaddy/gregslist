defmodule GregslistWeb.ChatLive.Index do 
  use GregslistWeb, :live_view 
  alias Gregslist.Accounts 
  alias Gregslist.Accounts.User 
  alias GregslistWeb.Endpoint

  #Learned about this function in https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:mount/3
  def mount(_params, session, socket) do
  
    if connected?(socket) do
      GregslistWeb.Endpoint.subscribe(topic())
    end

    {:ok, assign(socket, messages: [])}
  end
  
  #Learned about this function in https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_info/2
  def handle_info(%{event: "message", payload: message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end
  
  #Learned about this function in https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_event/3
  def handle_event("send", %{"text" => text}, socket) do
    email = socket.assigns.current_user.email
    username = String.split(email, "@") |> List.first()
    
    GregslistWeb.Endpoint.broadcast(topic(), "message", %{text: text, name: username})
    {:noreply, socket}
  end
  
  defp topic do
    "chat"
  end
end