defmodule Stygian.Skills.Skill do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Skills.SkillType

  @type t() :: %__MODULE__{
          description: String.t(),
          name: String.t(),
          is_attribute: boolean(),
          skill_types: [SkillType.t()],
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "skills" do
    field :description, :string
    field :name, :string
    field :is_attribute, :boolean, default: false, virtual: true

    many_to_many :skill_types, SkillType, join_through: "skills_rel_skill_types"

    timestamps()
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
