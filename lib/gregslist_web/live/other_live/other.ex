defmodule GregslistWeb.ItemLive.Other do
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Repo

  @impl true
  def mount(_params, _session, socket) do
    other_items =
      Galleries.list_items()
      |> Enum.filter(&(&1.categories == "other"))
      |> Repo.preload(:user)

    {:ok, assign(socket, other_items: other_items, sort_order: "asc")}
  end

  @impl true
  def handle_event("sort", %{"sort_order" => sort_order}, socket) do
    other_items =
      Galleries.list_items(sort_order)
      |> Enum.filter(&(&1.categories == "other"))
      |> Repo.preload(:user)

    {:noreply, assign(socket, other_items: other_items, sort_order: sort_order)}
  end

  def handle_event("div_clicked", %{"id" => item_id}, socket) do
    IO.puts("Div was clicked! Item ID: #{item_id}")

  {:noreply, push_redirect(socket, to: ~p"/items/#{item_id}/detail")}
  end
end
