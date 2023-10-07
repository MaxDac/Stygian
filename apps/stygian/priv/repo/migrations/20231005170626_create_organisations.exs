defmodule Stygian.Repo.Migrations.CreateOrganisations do
  use Ecto.Migration

  def change do
    create table(:organisations) do
      add :name, :string
      add :description, :text, null: true
      add :base_salary, :integer
      add :image, :text, null: true

      timestamps()
    end
  end
end
