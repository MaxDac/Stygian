defmodule Stygian.Repo.Migrations.CreateCharactersRelOrganisations do
  use Ecto.Migration

  def change do
    create table(:characters_rel_organisations) do
      add :character_id, references(:characters, on_delete: :delete_all)
      add :organisation_id, references(:organisations, on_delete: :delete_all)
      add :last_salary_withdraw, :naive_datetime, default: fragment("now()")
      add :end_date, :naive_datetime

      timestamps()
    end

    create index(:characters_rel_organisations, [:character_id])
    create index(:characters_rel_organisations, [:organisation_id])
  end
end
