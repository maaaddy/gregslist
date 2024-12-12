defmodule Gregslist.Repo.Migrations.AddAgeToUsers do
  use Ecto.Migration

  def change do
      alter table(:users) do
      add :age, :integer, null: false, default: 0  # Adjust the default and null constraints if needed
    end
  end
end
