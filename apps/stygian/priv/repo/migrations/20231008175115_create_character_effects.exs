defmodule Stygian.Repo.Migrations.CreateCharacterEffects do
  use Ecto.Migration

  def change do
    create table(:character_effects) do
      add :character_id, references(:characters, on_delete: :delete_all)
      add :object_id, references(:objects, on_delete: :delete_all)

      timestamps()
    end

    create index(:character_effects, [:character_id])
    create index(:character_effects, [:object_id])
  end
end
