defmodule Stygian.Repo.Migrations.CreateObjects do
  use Ecto.Migration

  def change do
    create table(:objects) do
      add :name, :string
      add :description, :text
      add :image_url, :text
      add :usages, :integer

      timestamps()
    end
  end
end
