defmodule GregslistWeb.ItemLive.Furniture do
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Repo

  @impl true
  def mount(_params, _session, socket) do
    furniture_items =
      Galleries.list_items()
      |> Enum.filter(&(&1.categories == "furniture"))
      |> Repo.preload(:user)

    {:ok, assign(socket, furniture_items: furniture_items, sort_order: "asc")}
  end

  @impl true
  def handle_event("sort", %{"sort_order" => sort_order}, socket) do
    furniture_items =
      Galleries.list_items(sort_order)
      |> Enum.filter(&(&1.categories == "furniture"))
      |> Repo.preload(:user)

    {:noreply, assign(socket, furniture_items: furniture_items, sort_order: sort_order)}
  end
end
