defmodule Gregslist.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :itemId, :integer
    field :dataUrl, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:itemId, :dataUrl])
    |> validate_required([:itemId, :dataUrl])
  end
end
