defmodule Gregslist.Galleries.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :user_name, :string
    field :categories
    field :desc, :string
    field :item_name, :string
    field :price, :float
    field :latitude, :float
    field :longitude, :float
    has_many :images, Gregslist.Image

    field :location, :string

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(),
           %{
             optional(atom()) =>
               atom()
               | {:array | :assoc | :embed | :in | :map | :parameterized | :supertype | :try,
                  any()}
           }}
          | %{
              :__struct__ => atom() | %{:__changeset__ => any(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(item, attrs) do
    item
    #|> cast(attrs, [:item_name, :category, :desc, :price, :location, :art_image])
    |> cast(attrs, [:item_name, :latitude, :longitude, :categories, :desc, :price, :location])
    |> validate_required([:item_name, :categories, :desc, :price, :location, :latitude, :longitude])
    |> validate_length(:desc, min: 2, max: 250)
  end

  def set_location(item) do
    %{item | location: "#{item.latitude}, #{item.longitude}"}
  end

end
