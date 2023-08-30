defmodule Stygian.Skills.Skill do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Skills.SkillType

  @attribute_skill_type_name "Attribute"

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

  @doc """
  Returns the item with the `is_attribute` field populated based on the skill type.
  """
  @spec add_is_attribute(t()) :: t()
  def add_is_attribute(skill)

  def add_is_attribute(%{skill_types: skill_types} = skill) when length(skill_types) > 0 do
    skill
    |> Map.put(:is_attribute, Enum.any?(skill_types, &(&1.name == @attribute_skill_type_name)))
  end

  def add_is_attribute(skill), do: skill
end
