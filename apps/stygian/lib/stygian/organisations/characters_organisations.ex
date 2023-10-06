defmodule Stygian.Organisations.CharactersOrganisations do
  @moduledoc """
  The relation between character and organisation, representing the work selected by the character.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Characters.Character
  alias Stygian.Organisations.Organisation

  @type t() :: %__MODULE__{
    last_salary_withdraw: NaiveDateTime.t(),
    end_date: NaiveDateTime.t(),
    character_id: non_neg_integer(),
    organisation_id: non_neg_integer(),
    character: Character.t(),
    organisation: Organisation.t(),

    inserted_at: NaiveDateTime.t(),
    updated_at: NaiveDateTime.t()
  }

  schema "characters_rel_organisations" do
    field :last_salary_withdraw, :naive_datetime
    field :end_date, :naive_datetime

    belongs_to :character, Stygian.Characters.Character
    belongs_to :organisation, Stygian.Organisations.Organisation

    timestamps()
  end

  @doc false
  def changeset(characters_organisations, attrs) do
    characters_organisations
    |> cast(attrs, [:character_id, :organisation_id, :last_salary_withdraw, :end_date])
    |> validate_required([:character_id, :organisation_id])
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:organisation_id)
  end
end
