defmodule Stygian.Repo.Migrations.CreateCombatActions do
  use Ecto.Migration

  def change do
    create table(:combat_actions) do
      add :name, :string, null: false
      add :description, :text
      add :minimum_skill_value, :integer
      add :does_damage, :boolean, default: true
      add :weapon_type_id, references(:weapon_types, on_delete: :delete_all)
      add :attack_attribute_id, references(:skills, on_delete: :delete_all)
      add :attack_skill_id, references(:skills, on_delete: :delete_all)
      add :defence_attribute_id, references(:skills, on_delete: :delete_all)
      add :defence_skill_id, references(:skills, on_delete: :delete_all)

      timestamps()
    end

    create index(:combat_actions, [:weapon_type_id])
    create index(:combat_actions, [:attack_attribute_id])
    create index(:combat_actions, [:attack_skill_id])
    create index(:combat_actions, [:defence_attribute_id])
    create index(:combat_actions, [:defence_skill_id])

    create unique_index(:combat_actions, [:name])
  end
end
