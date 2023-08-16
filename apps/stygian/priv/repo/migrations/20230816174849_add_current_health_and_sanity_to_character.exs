defmodule Stygian.Repo.Migrations.AddCurrentHealthAndSanityToCharacter do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :lost_health, :integer, default: 0
      add :lost_sanity, :integer, default: 0
    end
  end
end
