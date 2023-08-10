defmodule Stygian.Repo.Migrations.AddCharacterCustomSheet do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :custom_sheet, :string
    end
  end
end
