defmodule Stygian.Repo.Migrations.CreateCharacterSkills do
  use Ecto.Migration

  def change do
    create table(:character_skills) do
      add :value, :integer
      add :character_id, references(:characters, on_delete: :delete_all), null: false
      add :skill_id, references(:skills, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:character_skills, [:character_id])
    create index(:character_skills, [:skill_id])

    create unique_index(:character_skills, [:character_id, :skill_id])
  end
end
