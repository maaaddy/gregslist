defmodule GregslistWeb.ItemLive.Myitems do
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Repo
  @impl true

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns, label: "Socket assigns at mount start")
    user = socket.assigns[:current_user]
    if user do
      IO.inspect(user, label: "Current user")
      items =
        Galleries.list_items()
        |> Repo.preload(:images)
        |> Enum.filter(fn item -> item.user_id == user.id end)
        IO.inspect(items, label: "Filtered items")
      {:ok, assign(socket, user: user, items: items)}
    else
      IO.puts("No current_user found in socket.assigns")
      {:ok, assign(socket, user: nil, items: [])}
    end
  end

@impl true
  def handle_event("div_clicked", %{"id" => item_id}, socket) do
    IO.puts("Div was clicked! Item ID: #{item_id}")
    {:noreply, push_navigate(socket, to: ~p"/items/#{item_id}/edit")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <header class="mb-4">
      <h2 class="text-xl font-medium text-gray-400 flex items-center ml-2">
        <a href="/gregslist">
          <span class="mr-1">←</span>
          Back to Categories
        </a>
      </h2>
    </header>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <div class="bg-white p-4 rounded shadow">
      <div class="w-full text-center mt-8">
        <a href="/items/new " class = "text-9xl justify-center items-center">
          +
        </a>
      </div>
    </div>
      <%= if length(@items) == 0 do %>
        <div class="text-center text-gray-500">
          <p>You have no items listed yet.</p>
        </div>
      <% else %>
        <%= for item <- @items do %>
          <div class="bg-white p-4 rounded shadow relative"
          style="cursor: pointer;"phx-click={JS.push("div_clicked", value: %{id: item.id})}>
        <div class="flex justify-between items-center mb-4">
         <h3 class="font-semibold text-xl text-indigo-600"><%= item.item_name %></h3>
          <button
          phx-click="delete_item"
          phx-value-id={item.id}
          class="text-red-600 hover:text-red-800 font-semibold"
          >
          Delete
        </button>
      </div>
      <%= if item.images != nil && length(item.images) > 0 do %>
        <img
        src={hd(item.images).dataUrl}
        class="w-full h-40 object-cover rounded mb-4"
        alt="Item Image"
        />
      <% else %>
      <div class="w-full h-40 bg-gray-100 flex items-center justify-center rounded mb-4">
        <span class="text-gray-400">No Image Available</span>
      </div>
    <% end %>

    <p class="text-gray-600"><%= item.user.username %></p>
    <p class="text-gray-600"><%= item.desc %></p>
    <p class="text-green-600 font-semibold">$<%= item.price %></p>
    <p class="text-gray-500">Category: <%= item.categories %></p>
    <p class="text-gray-500">Location: <%= item.location %></p>
    </div>

        <% end %>
    <% end %>
    </div>
    """
  end
end
