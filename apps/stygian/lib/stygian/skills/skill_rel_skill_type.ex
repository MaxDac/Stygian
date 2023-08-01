defmodule Stygian.Skills.SkillRelSkillType do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Skills.Skill
  alias Stygian.Skills.SkillType

  schema "skills_rel_skill_types" do
    belongs_to :skill, Skill
    belongs_to :skill_type, SkillType

    timestamps()
  end

  @doc false
  def changeset(skill_rel, attrs) do
    skill_rel
    |> cast(attrs, [:skill_id, :skill_type_id])
    |> validate_required([:skill_id, :skill_type_id])
    |> foreign_key_constraint(:skills, name: :skills_rel_skill_types_skill_id_fkey)
    |> foreign_key_constraint(:skill_types, name: :skills_rel_skill_types_skill_type_id_fkey)
    |> unique_constraint([:skill_id, :skill_type_id])
  end
end
