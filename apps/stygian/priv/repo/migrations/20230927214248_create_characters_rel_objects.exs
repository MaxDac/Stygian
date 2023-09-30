defmodule Stygian.Repo.Migrations.CreateCharactersRelObjects do
  use Ecto.Migration

  def change do
    create table(:characters_rel_objects) do
      add :character_id, references(:characters, on_delete: :delete_all), null: false
      add :object_id, references(:objects, on_delete: :delete_all), null: false
      add :usages, :integer

      timestamps()
    end

    create index(:characters_rel_objects, [:character_id])
    create index(:characters_rel_objects, [:object_id])
  end
end
