defmodule Gregslist.Galleries.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :user_name, :string, default: "Stoli_Test"
    field :location, :string
    field :desc, :string
    field :item_name, :string
    field :price, :float, default: 0.0
    field :art_image, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:item_name, :desc, :price, :location, :art_image])
    |> validate_required([:item_name, :desc, :price, :location])
    |> validate_length(:desc, min: 2, max: 250)
  end
end
