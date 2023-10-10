defmodule Stygian.Repo.Migrations.AddObjectTableUniqueConstraint do
  use Ecto.Migration

  def change do
    create unique_index(:objects, [:name])
  end
end
