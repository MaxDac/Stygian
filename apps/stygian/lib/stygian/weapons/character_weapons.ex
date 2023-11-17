defmodule Stygian.Weapons.CharacterWeapons do
  @moduledoc """
  the many-to-many table for characters and weapons.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Characters.Character
  alias Stygian.Weapons.Weapon

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          character_id: non_neg_integer(),
          weapon_id: non_neg_integer(),
          character: Character.t(),
          weapon: Weapon.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "characters_weapons" do
    belongs_to :character, Character
    belongs_to :weapon, Weapon

    timestamps()
  end

  @doc false
  def changeset(character_weapons, attrs) do
    character_weapons
    |> cast(attrs, [:character_id, :weapon_id])
    |> cast_assoc(:character)
    |> cast_assoc(:weapon)
    |> validate_required([:character_id, :weapon_id])
  end
end
