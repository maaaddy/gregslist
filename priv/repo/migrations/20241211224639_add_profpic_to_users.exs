defmodule Gregslist.Repo.Migrations.AddProfpicToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:profile_pic_url, :string)
      end
  end
end
