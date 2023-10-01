defmodule Stygian.Repo.Migrations.AddObjectReferenceToTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :character_object_id, references(:characters_rel_objects, on_delete: :delete_all),
        null: true
    end

    create index(:transactions, [:character_object_id])
  end
end
