defmodule Stygian.Dices.CharacterActionForm do
  @moduledoc """
  The schema to support the action against a character form definition.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Dices.CharacterActionForm

  @type t() :: %__MODULE__{
          character_id: non_neg_integer(),
          action: :melee | :brawl | :grip | :firearm | :throw
        }

  embedded_schema do
    field :character_id, :id
    field :action, Ecto.Enum, values: [:melee, :brawl, :grip, :firearm, :throw]
  end

  @doc false
  def changeset(%CharacterActionForm{} = character_action_form, attrs) do
    character_action_form
    |> cast(attrs, [:character_id, :action])
    |> validate_required([:character_id, :action])
  end
end
