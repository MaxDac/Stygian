defmodule Stygian.Repo.Migrations.AddLastCigsEffect do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :last_cigs_effect, :naive_datetime, default: nil
    end
  end
end
