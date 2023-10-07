defmodule Stygian.Repo.Migrations.AddOrganisationNameConstraint do
  use Ecto.Migration

  def change do
    create unique_index(:organisations, [:name])
  end
end
