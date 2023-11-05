defmodule Stygian.Repo.Migrations.CreateChatActions do
  use Ecto.Migration

  def change do
    create table(:chat_actions) do
      add :resolved, :boolean, default: false, null: false
      add :accepted, :boolean, default: false, null: false
      add :action_id, references(:combat_actions, on_delete: :delete_all)
      add :attacker_id, references(:characters, on_delete: :delete_all)
      add :defender_id, references(:characters, on_delete: :delete_all)

      timestamps()
    end

    create index(:chat_actions, [:action_id])
    create index(:chat_actions, [:attacker_id])
    create index(:chat_actions, [:defender_id])
  end
end
