defmodule Stygian.Repo.Migrations.AddPngFlagToCharacter do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :npc, :boolean, default: false
    end
  end
end
