defmodule Gregslist.Galleries.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :location, :string
    field :categories
    field :desc, :string
    field :item_name, :string
    field :price, :float
    has_many :images, Gregslist.Image
    belongs_to :user, Gregslist.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:item_name, :categories, :desc, :price, :location, :user_id])
    |> validate_required([:item_name, :categories, :desc, :price, :location, :user_id])
    |> validate_length(:desc, min: 2, max: 250)
  end
end
