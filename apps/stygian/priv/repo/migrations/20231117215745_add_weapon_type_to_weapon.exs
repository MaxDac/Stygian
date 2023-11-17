defmodule Stygian.Repo.Migrations.AddWeaponTypeToWeapon do
  use Ecto.Migration

  def change do
    alter table(:weapons) do
      add :weapon_type_id, references(:weapon_types, on_delete: :delete_all)
    end

    create index(:weapons, [:weapon_type_id])
  end
end
