defmodule Stygian.Repo.Migrations.AddSkillsRelSkillTypes do
  use Ecto.Migration

  def change do
    create table(:skills_rel_skill_types) do
      add :skill_id, references(:skills, on_delete: :delete_all), null: false
      add :skill_type_id, references(:skill_types, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:skills_rel_skill_types, [:skill_id, :skill_type_id])
  end
end
