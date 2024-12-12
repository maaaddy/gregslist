defmodule GregslistWeb.ItemLive.Business do
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Repo

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns, label: "Socket assigns at mount start")
    user = socket.assigns[:current_user]

    if user do
      IO.inspect(user, label: "Current user")

      business_items =
        Galleries.list_items()
        |> Enum.filter(&(&1.categories == "business"))
        |> Repo.preload(:user)

      business_items = Enum.filter(business_items, fn item ->
        filter_by_age_restrictions(item, user)
      end)

      {:ok, assign(socket, business_items: business_items, sort_order: "asc", user: user)}
    else
      IO.puts("No current_user found in socket.assigns")
      {:ok, assign(socket, user: nil, business_items: [])}
    end
  end

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

  defp calculate_age(dob) do
    today = Date.utc_today()
    years_difference = today.year - dob.year
    if Date.compare(today, %{dob | year: today.year}) == :lt do
      years_difference - 1
    else
      years_difference
    end
  end

  @impl true
  def handle_event("sort", %{"sort_order" => sort_order}, socket) do
    user = socket.assigns[:user]

    if user do
      business_items =
        Galleries.list_items(sort_order)
        |> Enum.filter(&(&1.categories == "business"))
        |> Repo.preload(:user)

      
      business_items = Enum.filter(business_items, fn item ->
        filter_by_age_restrictions(item, user)
      end)

      {:noreply, assign(socket, business_items: business_items, sort_order: sort_order)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("div_clicked", %{"id" => item_id}, socket) do
    IO.puts("Div was clicked! Item ID: #{item_id}")

    {:noreply, push_redirect(socket, to: ~p"/items/#{item_id}/detail")}
  end
end