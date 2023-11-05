defmodule Stygian.Repo.Migrations.CreateWeaponTypes do
  use Ecto.Migration

  def change do
    create table(:weapon_types) do
      add :name, :string, null: false
      add :description, :text

      timestamps()
    end

    unique_index(:weapon_types, [:name])
  end
end
