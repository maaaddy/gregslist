defmodule Gregslist.Items.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "category" do
    field :name, :string
    timestamps()
  end

  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
