defmodule Stygian.Repo.Migrations.AddHealthAndSanityToObjects do
  use Ecto.Migration

  def change do
    alter table(:objects) do
      add :health, :integer, default: 0
      add :sanity, :integer, default: 0
    end
  end
end
