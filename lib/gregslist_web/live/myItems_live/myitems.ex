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
    <div class="bg-cover bg-center min-h-screen" style="background-image: url('/images/shopping.jpeg');">
      <div class="bg-black bg-opacity-50 min-h-screen pt-8">

        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 justify-center px-10">
          <div class="bg-white p-6 rounded-xl shadow-lg text-center hover:bg-teal-50 transition-all">
            <a href="/items/new" class="text-6xl text-teal-600 font-semibold">+</a>
            <p class="text-gray-500 font-semibold mt-4">Add New Item</p>
          </div>

          <%= if length(@items) == 0 do %>
            <div class="text-center text-gray-500 col-span-3">
              <p>You have no items listed yet.</p>
            </div>
          <% else %>
            <%= for item <- @items do %>
              <div class="bg-white p-6 rounded-xl shadow-lg relative hover:bg-teal-50 transition-all"
                   style="cursor: pointer;" phx-click={JS.push("div_clicked", value: %{id: item.id})}>
                <div class="flex justify-between items-center mb-4">
                  <h3 class="font-semibold text-xl text-teal-700"><%= item.item_name %></h3>
                  <.link href={~p"/items/#{item}"} method="delete" data-confirm="Are you sure?"
                         class="text-red-500 hover:text-red-600 font-medium">Delete</.link>
                </div>

                <%= if item.images != nil && length(item.images) > 0 do %>
                  <img src={hd(item.images).dataUrl}
                       class="w-full h-40 object-cover rounded-lg shadow-md mb-4" alt="Item Image" />
                <% else %>
                  <div class="w-full h-40 bg-gray-100 flex items-center justify-center rounded-lg shadow-md mb-4">
                    <span class="text-gray-400">No Image Available</span>
                  </div>
                <% end %>

                <p class="text-teal-600 font-semibold">$<%= item.price %></p>
                <p class="text-gray-500">Category: <%= item.categories %></p>
              </div>
            <% end %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
