defmodule Gregslist.Repo.Migrations.DropItemsTable do
  use Ecto.Migration

  def change do
    drop table(:items)
  end
end
