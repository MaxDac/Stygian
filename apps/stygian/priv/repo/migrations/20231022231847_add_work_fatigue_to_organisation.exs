defmodule Stygian.Repo.Migrations.AddWorkFatigueToOrganisation do
  use Ecto.Migration

  def change do
    alter table(:organisations) do
      add :work_fatigue, :integer, default: 0, null: false
    end
  end
end
