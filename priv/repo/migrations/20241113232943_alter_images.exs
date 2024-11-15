defmodule Gregslist.Repo.Migrations.AlterImages do
  use Ecto.Migration

  def change do
    alter table(:images) do
      add :item_id, references(:items, on_delete: :delete_all)
    end
  end
end
