defmodule Stygian.Organisations.CharctersOrganisations do
  @moduledoc """
  The relation between character and organisation, representing the work selected by the character.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "characters_rel_organisations" do
    field :character_id, :id
    field :organisation_id, :id
    field :last_salary_withdraw, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(charcters_organisations, attrs) do
    charcters_organisations
    |> cast(attrs, [:character_id, :organisation_id, :last_salary_withdraw])
    |> validate_required([:character_id, :organisation_id, :last_salary_withdraw])
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:organisation_id)
  end
end
