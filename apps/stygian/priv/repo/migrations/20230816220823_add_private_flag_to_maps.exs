defmodule Stygian.Repo.Migrations.AddPrivateFlagToMaps do
  use Ecto.Migration

  def change do
    alter table(:maps) do
      add :private, :boolean, default: false
    end
  end
end
