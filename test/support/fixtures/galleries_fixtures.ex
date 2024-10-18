defmodule Gregslist.GalleriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gregslist.Galleries` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        desc: "some desc",
        item_name: "some item_name",
        location: "some location",
        price: 120.5
      })
      |> Gregslist.Galleries.create_item()

    item
  end
end
