defmodule Stygian.Weapons.Weapon do
  @moduledoc """
  The Weapon schema.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Skills.Skill

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          name: String.t(),
          description: String.t(),
          image_url: String.t(),
          cost: non_neg_integer(),
          damage_bonus: non_neg_integer(),
          required_skill_min_value: non_neg_integer(),
          required_skill_id: non_neg_integer(),
          required_skill: Skill.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "weapons" do
    field :name, :string
    field :description, :string
    field :image_url, :string
    field :cost, :integer
    field :damage_bonus, :integer
    field :required_skill_min_value, :integer

    belongs_to :required_skill, Skill

    timestamps()
  end

  @doc false
  def changeset(weapon, attrs) do
    weapon
    |> cast(attrs, [
      :name,
      :description,
      :image_url,
      :required_skill_min_value,
      :damage_bonus,
      :cost,
      :required_skill_id
    ])
    |> validate_required([
      :name,
      :description,
      :image_url,
      :required_skill_min_value,
      :damage_bonus,
      :cost,
      :required_skill_id
    ])
    |> foreign_key_constraint(:required_skill_id, name: :weapons_required_skill_id_fkey)
  end
end
