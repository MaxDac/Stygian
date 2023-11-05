defmodule Stygian.Combat.WeaponType do
  @moduledoc """
  The weapon type schema. 
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{
          id: integer(),
          name: String.t(),
          description: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "weapon_types" do
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(weapon_type, attrs) do
    weapon_type
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
