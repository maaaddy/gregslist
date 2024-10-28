defmodule Gregslist.Repo.Migrations.UpdateUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
    add(:username, :string)
    add(:dob, :date)
    add(:zipcode, :integer)
    end
  end
end
