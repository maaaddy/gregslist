defmodule GregslistWeb.ItemLive.Business do
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Galleries.Item

  @impl true
  def mount(_params, _session, socket) do

    business_items = Galleries.list_items() |> Enum.filter(&(&1.categories == "business"))
    
    {:ok, assign(socket, business_items: business_items, sort_order: "asc")}
  end

  @impl true
  def handle_event("sort", %{"sort_order" => sort_order}, socket) do
    business_items = Galleries.list_items(sort_order) |> Enum.filter(&(&1.categories == "business"))
    {:noreply, assign(socket, business_items: business_items, sort_order: sort_order)}
  end

end