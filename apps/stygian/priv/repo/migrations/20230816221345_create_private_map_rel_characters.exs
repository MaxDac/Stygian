defmodule Stygian.Repo.Migrations.CreatePrivateMapRelCharacters do
  use Ecto.Migration

  def change do
    create table(:private_map_rel_characters) do
      add :character_id, references(:characters, on_delete: :nothing)
      add :map_id, references(:maps, on_delete: :nothing)
      add :host, :boolean, default: false, null: false

      timestamps()
    end

    create index(:private_map_rel_characters, [:character_id])
    create index(:private_map_rel_characters, [:map_id])
  end
end
