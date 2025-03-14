defmodule GregslistWeb.SearchLive do
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Repo

  @impl true
  def mount(_params, _session, socket) do
    # Fetch the current user from socket assigns
    user = socket.assigns[:current_user]

    if user do
      IO.inspect(user, label: "Current user")

      # Fetch all items and apply age restrictions
      items =
        Galleries.list_items()
        |> Repo.preload(:user)
        |> Enum.filter(&filter_by_age_restrictions(&1, user))

      {:ok, assign(socket, items: items, search: nil, category: nil, min_price: nil, max_price: nil, location: nil, user: user)}
    else
      IO.puts("No current_user found in socket.assigns")
      {:ok, assign(socket, items: [], search: nil, category: nil, min_price: nil, max_price: nil, location: nil, user: nil)}
    end
  end

  @impl true
  def handle_event("div_clicked", %{"id" => item_id}, socket) do
    IO.puts("Div was clicked! Item ID: #{item_id}")

    {:noreply, push_redirect(socket, to: ~p"/items/#{item_id}/detail")}
  end

  @impl true
  def handle_event("filter", %{"search" => search_term, "category" => category, "min_price" => min_price, "max_price" => max_price, "location" => location}, socket) do
    user = socket.assigns[:user]

    if user do
      # Parse price inputs
      min_price = parse_price(min_price)
      max_price = parse_price(max_price)

      # Fetch and filter items based on search criteria and age restrictions
      items =
        Galleries.list_items()
        |> Repo.preload(:user)
        |> filter_by_name(search_term)
        |> filter_by_category(category)
        |> filter_by_price(min_price, max_price)
        |> filter_by_location(location)
        |> Enum.filter(&filter_by_age_restrictions(&1, user))

      {:noreply, assign(socket, items: items, search: search_term, category: category, min_price: min_price, max_price: max_price, location: location)}
    else
      {:noreply, socket}
    end
  end

  # Helper function to filter items by age restrictions
  defp filter_by_age_restrictions(item, user) do
    case user.dob do
      nil -> false  # If no DOB, filter out the item
      dob ->
        age = calculate_age(dob)
        cond do
          item.restricted_21 -> age >= 21
          item.restricted_18 -> age >= 18
          true -> true
        end
    end
  end

  # Helper function to calculate age
  defp calculate_age(dob) do
    today = Date.utc_today()
    years_difference = today.year - dob.year
    if Date.compare(today, %{dob | year: today.year}) == :lt do
      years_difference - 1
    else
      years_difference
    end
  end

  # Helper function to parse price values
  defp parse_price(nil), do: nil
  defp parse_price(""), do: nil
  defp parse_price(price) do
    case Float.parse(price) do
      {float, _} -> float
      :error -> nil
    end
  end

  # Helper function to filter items by category
  defp filter_by_category(items, ""), do: items
  defp filter_by_category(items, category), do: Enum.filter(items, &(&1.categories == category))

  # Helper function to filter items by price range
  defp filter_by_price(items, nil, nil), do: items
  defp filter_by_price(items, min_price, nil) when not is_nil(min_price), do: Enum.filter(items, &(&1.price >= min_price))
  defp filter_by_price(items, nil, max_price) when not is_nil(max_price), do: Enum.filter(items, &(&1.price <= max_price))
  defp filter_by_price(items, min_price, max_price) when not is_nil(min_price) and not is_nil(max_price) do
    Enum.filter(items, &(&1.price >= min_price and &1.price <= max_price))
  end

  # Helper function to filter items by location with partial match
  defp filter_by_location(items, nil), do: items
  defp filter_by_location(items, ""), do: items
  defp filter_by_location(items, location) do
    Enum.filter(items, fn item ->
      String.contains?(String.downcase(item.location || ""), String.downcase(location))
    end)
  end

  # Helper function to filter items by name with partial match
  defp filter_by_name(items, ""), do: items
  defp filter_by_name(items, search_term) do
    Enum.filter(items, fn item ->
      String.contains?(String.downcase(item.item_name), String.downcase(search_term))
    end)
  end


@impl true
def render(assigns) do
  ~H"""
  <div class="relative w-full h-max-screen bg-cover bg-center pt-8" style="background-image: url('/images/shopping.jpeg');">
    <div class="absolute inset-0 bg-black bg-opacity-50"></div>

    <div class="relative z-10 mx-auto max-w-6xl p-8 rounded-2xl shadow-lg bg-white bg-opacity-90">
      <h2 class="text-xl font-medium text-gray-800 flex items-center ml-2 mb-6">
        <a href="/gregslist">
          <span class="mr-1">←</span>
          Back to Categories
        </a>
      </h2>

      <h1 class="text-5xl font-extrabold text-center text-teal-600 mb-8">
        Search Listings
      </h1>

      <!-- Name Search Input at the top -->
      <form phx-change="filter">
        <div class="mb-8">
          <div class="flex space-x-4 justify-center">
            <div class="w-full md:w-1/2">
              <label for="search" class="text-gray-700 sr-only">Search by Name</label>
              <input type="text" id="search" name="search" value={@search || ""} placeholder="Search by name..." class="border p-2 rounded w-full focus:outline-none focus:ring-3 focus:ring-teal-600" />
            </div>
          </div>
        </div>

        <!-- Filters Section -->
        <div class="bg-gray-50 p-4 rounded-lg shadow-md">
          <div class="flex flex-wrap gap-4 justify-between">
            <!-- Category Filter Dropdown -->
            <div class="w-full sm:w-1/4">
              <label for="category" class="text-gray-700 font-semibold mb-2 block">Category</label>
              <select id="category" name="category" class="border p-2 rounded w-full focus:outline-none focus:ring-2 focus:ring-teal-600">
                <option value="">All</option>
                <option value="technology" selected={@category == "technology"}>Technology</option>
                <option value="furniture" selected={@category == "furniture"}>Furniture</option>
                <option value="vehicles" selected={@category == "vehicles"}>Vehicles</option>
                <option value="clothes" selected={@category == "clothes"}>Clothing</option>
                <option value="business" selected={@category == "business"}>Business</option>
                <option value="other" selected={@category == "other"}>Other</option>
              </select>
            </div>

            <!-- Min Price Input -->
            <div class="w-full sm:w-1/5">
              <label for="min_price" class="text-gray-700 font-semibold mb-2 block">Min Price</label>
              <input type="number" id="min_price" name="min_price" value={@min_price || ""} class="border p-2 rounded w-full focus:outline-none focus:ring-2 focus:ring-teal-600" placeholder="Min Price" />
            </div>

            <!-- Max Price Input -->
            <div class="w-full sm:w-1/5">
              <label for="max_price" class="text-gray-700 font-semibold mb-2 block">Max Price</label>
              <input type="number" id="max_price" name="max_price" value={@max_price || ""} class="border p-2 rounded w-full focus:outline-none focus:ring-2 focus:ring-teal-600" placeholder="Max Price" />
            </div>

            <!-- Location Filter Input -->
            <div class="w-full sm:w-1/4">
              <label for="location" class="text-gray-700 font-semibold mb-2 block">Location</label>
              <input type="text" id="location" name="location" value={@location || ""} class="border p-2 rounded w-full focus:outline-none focus:ring-2 focus:ring-teal-600" placeholder="Location" />
            </div>
          </div>
        </div>
      </form>

      <!-- Search Results -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 mt-8">
        <%= for item <- @items do %>
          <div class="bg-white p-4 rounded shadow-lg hover:shadow-xl transition-shadow cursor-pointer" phx-click={JS.push("div_clicked", value: %{id: item.id})}>
            <%= if item.images != nil && length(item.images) > 0 do %>
              <img src={hd(item.images).dataUrl}
                class="w-full h-40 object-cover rounded mb-4"
                alt="Item Image"
              />
            <% end %>
            <h3 class="font-semibold text-xl text-teal-600"><%= item.item_name %></h3>
            <p class="text-gray-800 font-semibold">$<%= item.price %></p>
          </div>
        <% end %>
      </div>
    </div>
  </div>
  """
end


end
