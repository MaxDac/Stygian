defmodule Stygian.Repo.Migrations.CreateMaps do
  use Ecto.Migration

  def change do
    create table(:maps) do
      add :name, :string, null: false
      add :description, :text
      add :image_name, :string, null: false
      add :coords, :string
      add :coords_type, :string
      add :parent_id, references(:maps, on_delete: :delete_all)

      timestamps()
    end

    create index(:maps, [:parent_id])
    create unique_index(:maps, [:name])
  end
end
