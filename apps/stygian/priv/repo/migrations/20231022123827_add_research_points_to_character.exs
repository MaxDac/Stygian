defmodule Stygian.Repo.Migrations.AddResearchPointsToCharacter do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :research_points, :integer, default: 0
    end
  end
end
