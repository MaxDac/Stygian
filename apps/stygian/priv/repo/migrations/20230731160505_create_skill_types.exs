defmodule Stygian.Repo.Migrations.CreateSkillTypes do
  use Ecto.Migration

  def change do
    create table(:skill_types) do
      add :name, :string, null: false
      add :description, :text

      timestamps()
    end

    create unique_index(:skill_types, [:name])
  end
end
