defmodule Stygian.Objects.CharacterObject do
  @moduledoc """
  This table relates the characters to their inventory objects.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Characters.Character
  alias Stygian.Objects.Object

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          character_id: non_neg_integer(),
          object_id: non_neg_integer(),
          usages: integer(),
          character: Character.t(),
          object: Object.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "characters_rel_objects" do
    field :usages, :integer

    belongs_to :character, Character
    belongs_to :object, Object

    timestamps()
  end

  @doc false
  def changeset(character_object, attrs) do
    character_object
    |> cast(attrs, [:usages, :character_id, :object_id])
    |> validate_required([:usages, :character_id, :object_id])
    |> foreign_key_constraint(:characters, name: :characters_rel_objects_character_id_fkey)
    |> foreign_key_constraint(:objects, name: :characters_rel_objects_object_id_fkey)
  end
end
