defmodule Stygian.Combat.Action do
  @moduledoc """
  The Combat Action schema.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Weapons.WeaponType
  alias Stygian.Skills.Skill

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          name: String.t(),
          description: String.t(),
          minimum_skill_value: non_neg_integer(),
          does_damage: boolean(),
          weapon_type_id: non_neg_integer(),
          attack_attribute_id: non_neg_integer(),
          attack_skill_id: non_neg_integer(),
          defence_attribute_id: non_neg_integer(),
          defence_skill_id: non_neg_integer(),
          weapon_type: WeaponType.t(),
          attack_attribute: Skill.t(),
          attack_skill: Skill.t(),
          defence_attribute: Skill.t(),
          defence_skill: Skill.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "combat_actions" do
    field :name, :string
    field :description, :string
    field :minimum_skill_value, :integer
    field :does_damage, :boolean, default: true

    belongs_to :weapon_type, WeaponType
    belongs_to :attack_attribute, Skill
    belongs_to :attack_skill, Skill
    belongs_to :defence_attribute, Skill
    belongs_to :defence_skill, Skill

    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [
      :name,
      :description,
      :minimum_skill_value,
      :does_damage,
      :weapon_type_id,
      :attack_attribute_id,
      :attack_skill_id,
      :defence_attribute_id,
      :defence_skill_id
    ])
    |> validate_required([
      :name,
      :description,
      :minimum_skill_value,
      :weapon_type_id,
      :attack_attribute_id,
      :attack_skill_id,
      :defence_attribute_id,
      :defence_skill_id
    ])
    |> foreign_key_constraint(:weapon_type_id)
    |> foreign_key_constraint(:attack_attribute_id)
    |> foreign_key_constraint(:attack_skill_id)
    |> foreign_key_constraint(:defence_attribute_id)
    |> foreign_key_constraint(:defence_skill_id)
    |> unique_constraint(:name, name: :unique_combat_action_name)
  end
end
