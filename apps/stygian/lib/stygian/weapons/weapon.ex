defmodule Stygian.Weapons.Weapon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weapons" do
    field :name, :string
    field :description, :string
    field :image_url, :string
    field :required_skill_min_value, :integer
    field :damage_bonus, :integer
    field :cost, :integer
    field :required_skill_id, :id

    timestamps()
  end

  @doc false
  def changeset(weapon, attrs) do
    weapon
    |> cast(attrs, [:name, :description, :image_url, :required_skill_min_value, :damage_bonus, :cost])
    |> validate_required([:name, :description, :image_url, :required_skill_min_value, :damage_bonus, :cost])
  end
end
