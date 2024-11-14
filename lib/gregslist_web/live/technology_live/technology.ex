defmodule GregslistWeb.ItemLive.Technology do
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Galleries.Item

  @impl true
  def mount(_params, _session, socket) do

    technology_items = Galleries.list_items() |> Enum.filter(&(&1.categories == "technology"))
    
    {:ok, assign(socket, technology_items: technology_items, sort_order: "asc")}
  end

  @impl true
  def handle_event("sort", %{"sort_order" => sort_order}, socket) do
    technology_items = Galleries.list_items(sort_order) |> Enum.filter(&(&1.categories == "technology"))
    {:noreply, assign(socket, technology_items: technology_items, sort_order: sort_order)}
  end

end