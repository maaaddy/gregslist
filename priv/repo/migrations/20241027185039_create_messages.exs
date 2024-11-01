defmodule Gregslist.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :sender_id, references(:users, on_delete: :delete_all), null: false
      add :receiver_id, references(:users, on_delete: :delete_all), null: false
      add :content, :text, null: false
      add :timestamp, :utc_datetime, default: fragment("CURRENT_TIMESTAMP"), null: false

      timestamps()
    end

    create index(:messages, [:sender_id])
    create index(:messages, [:receiver_id])
  end
end
