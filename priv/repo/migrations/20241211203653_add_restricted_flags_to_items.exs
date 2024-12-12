defmodule Gregslist.Repo.Migrations.AddRestrictedFlagsToItems do
  use Ecto.Migration

  def change do
  alter table(:items) do
      add :restricted_18, :boolean, default: false, null: false
      add :restricted_21, :boolean, default: false, null: false
    end

  end
end
