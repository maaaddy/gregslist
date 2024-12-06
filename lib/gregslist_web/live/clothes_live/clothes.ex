defmodule GregslistWeb.ItemLive.Clothes do
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Repo

  @impl true
  def mount(_params, _session, socket) do
    clothes_items =
      Galleries.list_items()
      |> Enum.filter(&(&1.categories == "clothes"))
      |> Repo.preload(:user)

    {:ok, assign(socket, clothes_items: clothes_items, sort_order: "asc")}
  end

  @impl true
  def handle_event("sort", %{"sort_order" => sort_order}, socket) do
    clothes_items =
      Galleries.list_items(sort_order)
      |> Enum.filter(&(&1.categories == "clothes"))
      |> Repo.preload(:user)

    {:noreply, assign(socket, clothes_items: clothes_items, sort_order: sort_order)}
  end

def handle_event("div_clicked", %{"id" => item_id}, socket) do
    IO.puts("Div was clicked! Item ID: #{item_id}")

  {:noreply, push_redirect(socket, to: ~p"/items/#{item_id}/detail")}
  end

end
