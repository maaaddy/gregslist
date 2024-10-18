defmodule Gregslist.Galleries.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :location, :string
    field :desc, :string
    field :item_name, :string
    field :price, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:item_name, :desc, :price, :location])
    |> validate_required([:item_name, :desc, :price, :location])
  end
end
