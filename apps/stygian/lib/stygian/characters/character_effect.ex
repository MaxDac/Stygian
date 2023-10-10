defmodule Stygian.Characters.CharacterEffect do
  @moduledoc """
  Represents the effect that the character has from a particular object. 
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Characters.Character
  alias Stygian.Objects.Object

  @type t() :: %__MODULE__{
          id: integer(),
          character_id: integer(),
          object_id: integer(),
          character: Character.t(),
          object: Object.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "character_effects" do
    belongs_to :character, Character
    belongs_to :object, Object

    timestamps()
  end

  @doc false
  def changeset(character_effect, attrs) do
    character_effect
    |> cast(attrs, [:character_id, :object_id])
    |> validate_required([:character_id, :object_id])
  end

  @doc """
  This changeset must only be used in unit tests, as it allows to manually define the inserted_at date.
  """
  def changeset_test(character_effect, attrs) do
    character_effect
    |> cast(attrs, [:character_id, :object_id, :inserted_at])
    |> validate_required([:character_id, :object_id])
  end
end
