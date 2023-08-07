defmodule Stygian.Repo.Migrations.AddSmallAvatarToCharacter do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :small_avatar, :text, null: true
    end
  end
end
