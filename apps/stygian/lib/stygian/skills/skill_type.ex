defmodule Stygian.Skills.SkillType do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Skills.Skill

  @type t() :: %__MODULE__{
          description: String.t(),
          name: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "skill_types" do
    field :description, :string
    field :name, :string

    many_to_many :skills, Skill, join_through: "skill_rel_skill_types"

    timestamps()
  end

  @doc false
  def changeset(skill_type, attrs) do
    skill_type
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
