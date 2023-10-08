defmodule Stygian.Objects.Effect do
  @moduledoc """
  The object effect schema.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Skills.Skill
  alias Stygian.Objects.Object

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          value: integer(),
          object_id: non_neg_integer(),
          skill_id: non_neg_integer(),
          object: Object.t(),
          skill: Skill.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "object_effects" do
    field :value, :integer

    belongs_to :object, Object
    belongs_to :skill, Skill

    timestamps()
  end

  @doc false
  def changeset(effect, attrs) do
    effect
    |> cast(attrs, [:object_id, :skill_id, :value])
    |> validate_required([:object_id, :skill_id, :value])
    |> foreign_key_constraint(:object_id)
    |> foreign_key_constraint(:skill_id)
  end
end
