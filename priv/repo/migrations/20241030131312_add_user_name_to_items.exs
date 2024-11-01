defmodule Gregslist.Repo.Migrations.AddUserNameToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :user_name, :string
    end
    end
end
