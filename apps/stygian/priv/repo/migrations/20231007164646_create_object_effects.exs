defmodule Stygian.Repo.Migrations.CreateObjectEffects do
  use Ecto.Migration

  def change do
    create table(:object_effects) do
      add :value, :integer
      add :object_id, references(:objects, on_delete: :delete_all)
      add :skill_id, references(:skills, on_delete: :delete_all)

      timestamps()
    end

    create index(:object_effects, [:object_id])
    create index(:object_effects, [:skill_id])
  end
end
