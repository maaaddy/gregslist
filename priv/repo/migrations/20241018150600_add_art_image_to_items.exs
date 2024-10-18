defmodule Gregslist.Repo.Migrations.AddArtImageToItems do
  use Ecto.Migration

  def change do
  alter table(:items) do
  add(:art_image, :string)
end
  end
end
