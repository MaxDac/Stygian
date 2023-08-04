defmodule Stygian.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string, null: false
      add :avatar, :text
      add :biography, :text
      add :description, :text
      add :cigs, :integer
      add :notes, :text
      add :admin_notes, :text
      add :experience, :integer
      add :health, :integer
      add :sanity, :integer
      add :step, :integer
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:characters, [:user_id])
    create unique_index(:characters, [:name])
  end
end
