defmodule Gregslist.Repo.Migrations.AddedCategories do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :categories, :string
    end
  end
end
