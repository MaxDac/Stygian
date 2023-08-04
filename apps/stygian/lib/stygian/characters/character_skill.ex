defmodule Stygian.Characters.CharacterSkill do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Characters.Character
  alias Stygian.Skills.Skill

  @type t() :: %__MODULE__{
          value: integer(),
          character_id: integer(),
          skill_id: integer(),
          character: Character.t(),
          skill: Skill.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "character_skills" do
    field :value, :integer

    belongs_to :character, Character
    belongs_to :skill, Skill

    timestamps()
  end

  @doc false
  def changeset(character_skill, attrs) do
    character_skill
    |> cast(attrs, [:value, :character_id, :skill_id])
    |> validate_required([:value, :character_id, :skill_id])
    |> foreign_key_constraint(:character_id, name: :character_skills_character_id_fkey)
    |> foreign_key_constraint(:skill_id, name: :character_skills_skill_id_fkey)
    |> unique_constraint([:character_id, :skill_id])
  end
end
