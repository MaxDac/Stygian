defmodule Stygian.Weapons.WeaponAssignForm do
  @moduledoc """
  Form that specify the assignment of a weapon to a character.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Weapons.WeaponAssignForm

  @type t() :: %__MODULE__{
          character_id: non_neg_integer(),
          weapon_id: non_neg_integer()
        }

  embedded_schema do 
    field :character_id, :id
    field :weapon_id, :id
  end

  @doc false
  def changeset(%WeaponAssignForm{} = weapon_assign_form, attrs) do
    weapon_assign_form
    |> cast(attrs, [:character_id, :weapon_id])
    |> validate_required([:character_id, :weapon_id])
  end
end
