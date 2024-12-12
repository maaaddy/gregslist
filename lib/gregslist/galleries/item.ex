defmodule Gregslist.Galleries.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :location, :string
    field :categories
    field :desc, :string
    field :item_name, :string
    field :price, :float
    field :restricted_18, :boolean, default: false
  field :restricted_21, :boolean, default: false
    has_many :images, Gregslist.Image
    belongs_to :user, Gregslist.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:restricted_18, :restricted_21, :item_name, :categories, :desc, :price, :location, :user_id])
    |> validate_required([:item_name, :categories, :desc, :price, :location, :user_id])
    |> validate_length(:desc, min: 2, max: 250)
  end
end
