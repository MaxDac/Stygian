defmodule Stygian.Repo.Migrations.CreateCharactersRelOrganisations do
  use Ecto.Migration

  def change do
    create table(:characters_rel_organisations) do
      add :last_salary_withdraw, :naive_datetime
      add :character_id, references(:characters, on_delete: :nothing)
      add :organisation_id, references(:organisations, on_delete: :nothing)

      timestamps()
    end

    create index(:characters_rel_organisations, [:character_id])
    create index(:characters_rel_organisations, [:organisation_id])
  end
end
