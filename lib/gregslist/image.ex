defmodule Gregslist.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Gregslist.Repo

  @derive {Jason.Encoder, only: [:itemId, :dataUrl]}

  schema "images" do
    field :itemId, :integer
    field :dataUrl, :string
    belongs_to :items, Gregslist.Galleries.Item, foreign_key: :item_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:itemId, :dataUrl, :item_id])
    |> validate_required([:itemId, :dataUrl, :item_id])
    |> foreign_key_constraint(:item_id)
  end

  def insert(attrs \\ %{}) do
    %Gregslist.Image{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
