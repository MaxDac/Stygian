defmodule Stygian.Repo.Migrations.CreateWeapons do
  use Ecto.Migration

  def change do
    create table(:weapons) do
      add :name, :string
      add :description, :text
      add :image_url, :text
      add :required_skill_min_value, :integer
      add :damage_bonus, :integer
      add :cost, :integer
      add :required_skill_id, references(:skills, on_delete: :nothing)

      timestamps()
    end

    create index(:weapons, [:required_skill_id])
  end
end
