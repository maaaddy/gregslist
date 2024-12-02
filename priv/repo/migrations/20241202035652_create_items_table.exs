defmodule Gregslist.Repo.Migrations.CreateItemsTable do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :location, :string
      add :categories, :string
      add :desc, :string
      add :item_name, :string
      add :price, :float
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end
  end
end
