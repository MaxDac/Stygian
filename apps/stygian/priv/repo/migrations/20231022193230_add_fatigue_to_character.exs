defmodule Stygian.Repo.Migrations.AddFatigueToCharacter do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :fatigue, :integer, default: 0
    end
  end
end
