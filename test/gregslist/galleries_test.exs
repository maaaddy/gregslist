defmodule Gregslist.GalleriesTest do
  use Gregslist.DataCase

  alias Gregslist.Galleries

  describe "items" do
    alias Gregslist.Galleries.Item

    import Gregslist.GalleriesFixtures

    @invalid_attrs %{location: nil, desc: nil, item_name: nil, price: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Galleries.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Galleries.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{location: "some location", desc: "some desc", item_name: "some item_name", price: 120.5}

      assert {:ok, %Item{} = item} = Galleries.create_item(valid_attrs)
      assert item.location == "some location"
      assert item.desc == "some desc"
      assert item.item_name == "some item_name"
      assert item.price == 120.5
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Galleries.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{location: "some updated location", desc: "some updated desc", item_name: "some updated item_name", price: 456.7}

      assert {:ok, %Item{} = item} = Galleries.update_item(item, update_attrs)
      assert item.location == "some updated location"
      assert item.desc == "some updated desc"
      assert item.item_name == "some updated item_name"
      assert item.price == 456.7
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Galleries.update_item(item, @invalid_attrs)
      assert item == Galleries.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Galleries.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Galleries.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Galleries.change_item(item)
    end
  end
end
