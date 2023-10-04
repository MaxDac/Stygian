defmodule Stygian.Characters.CharacterSkillForm do
  @moduledoc """
  A form to handle the changes of character skill values. 
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Characters.CharacterSkillForm

  @type t() :: %__MODULE__{
          character_id: non_neg_integer(),
          skill_id: non_neg_integer(),
          new_value: non_neg_integer()
        }

  embedded_schema do
    field :character_id, :id
    field :skill_id, :id
    field :new_value, :integer
  end

  @doc false
  def changeset(%CharacterSkillForm{} = character_skill_form, attrs) do
    character_skill_form
    |> cast(attrs, [:character_id, :skill_id, :new_value])
    |> validate_required([:character_id, :skill_id, :new_value])
  end
end
