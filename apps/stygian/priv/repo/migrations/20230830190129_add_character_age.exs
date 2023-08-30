defmodule Stygian.Repo.Migrations.AddCharacterAge do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :age, :string, null: false, default: "young"
      add :sin, :text
    end
  end
end
