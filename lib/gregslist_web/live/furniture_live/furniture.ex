defmodule GregslistWeb.ItemLive.Furniture do
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Galleries.Item

  @impl true
  def mount(_params, _session, socket) do
    furniture_items = Galleries.list_items() |> Enum.filter(&(&1.categories == "furniture"))
    
    {:ok, assign(socket, furniture_items: furniture_items)}
  end
end
