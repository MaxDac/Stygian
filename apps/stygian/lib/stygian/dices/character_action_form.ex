defmodule Stygian.Dices.CharacterActionForm do
  @moduledoc """
  The schema to support the action against a character form definition.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Dices.CharacterActionForm

  @type t() :: %__MODULE__{
          attacker_character_id: non_neg_integer(),
          defending_character_id: non_neg_integer(),
          combat_action_id: non_neg_integer()
        }

  embedded_schema do
    field :attacker_character_id, :id
    field :defending_character_id, :id
    field :combat_action_id, :id
  end

  @doc false
  def changeset(%CharacterActionForm{} = character_action_form, attrs) do
    character_action_form
    |> cast(attrs, [:attacker_character_id, :defending_character_id, :combat_action_id])
    |> validate_required([:attacker_character_id, :defending_character_id, :combat_action_id])
  end
end
