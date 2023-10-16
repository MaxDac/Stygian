defmodule Stygian.Repo.Migrations.CreateRestActions do
  use Ecto.Migration

  def change do
    create table(:rest_actions) do
      add :name, :string
      add :description, :text
      add :health, :integer
      add :sanity, :integer
      add :research_points, :integer
      add :slots, :integer

      timestamps()
    end

    create unique_index(:rest_actions, [:name])
  end
end
