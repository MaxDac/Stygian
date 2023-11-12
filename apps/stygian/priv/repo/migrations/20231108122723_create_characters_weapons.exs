defmodule Stygian.Repo.Migrations.CreateCharactersWeapons do
  use Ecto.Migration

  def change do
    create table(:characters_weapons) do
      add :character_id, references(:characters, on_delete: :nothing)
      add :weapon_id, references(:weapons, on_delete: :nothing)

      timestamps()
    end

    create index(:characters_weapons, [:character_id])
    create index(:characters_weapons, [:weapon_id])
  end
end
