defmodule Stygian.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :text, :text, null: false
      add :type, :string, null: false
      add :character_id, references(:characters, on_delete: :delete_all), null: false
      add :map_id, references(:maps, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:chats, [:character_id])
    create index(:chats, [:map_id])
  end
end
