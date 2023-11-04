defmodule Stygian.Combat.WeaponType do
  @moduledoc """
  The weapon type schema. 
  """

  use Ecto.Schema

  import Ecto.Changeset

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
