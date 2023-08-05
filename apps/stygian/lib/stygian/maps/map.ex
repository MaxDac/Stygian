defmodule Stygian.Maps.Map do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Maps.Map

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          description: String.t(),
          image_name: String.t(),
          coords: String.t(),
          coords_type: String.t(),
          parent_id: integer(),
          parent: Map.t(),
          children: list(Map.t()),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "maps" do
    field :description, :string
    field :image_name, :string
    field :name, :string
    field :coords, :string
    field :coords_type, :string

    belongs_to :parent, Map, foreign_key: :parent_id
    has_many :children, Map, foreign_key: :parent_id

    timestamps()
  end

  @doc false
  def changeset(map, attrs) do
    map
    |> cast(attrs, [:name, :description, :image_name, :coords, :coords_type, :parent_id])
    |> foreign_key_constraint(:parent_id)
    |> validate_required([:name])
  end
end
