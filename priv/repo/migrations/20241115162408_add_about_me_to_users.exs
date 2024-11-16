defmodule Gregslist.Repo.Migrations.AddAboutMeToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :about_me, :string
    end
  end
end
