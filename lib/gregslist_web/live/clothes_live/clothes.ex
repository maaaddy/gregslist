defmodule GregslistWeb.ItemLive.Clothes do
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Galleries.Item

  @impl true
  def mount(_params, _session, socket) do

    clothes_items = Galleries.list_items() |> Enum.filter(&(&1.categories == "clothes"))
    
    {:ok, assign(socket, clothes_items: clothes_items, sort_order: "asc")}
  end

  @impl true
  def handle_event("sort", %{"sort_order" => sort_order}, socket) do
    clothes_items = Galleries.list_items(sort_order) |> Enum.filter(&(&1.categories == "clothes"))
    {:noreply, assign(socket, clothes_items: clothes_items, sort_order: sort_order)}
  end

end