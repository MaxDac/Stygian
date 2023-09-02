defmodule Stygian.Repo.Migrations.AddRestTimerToCharacter do
  use Ecto.Migration

  def change do
    alter  table(:characters) do
      add :rest_timer, :naive_datetime
    end
  end
end
