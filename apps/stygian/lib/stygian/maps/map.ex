defmodule Stygian.Maps.Map do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Maps.Map
  alias Stygian.Maps.PrivateMapCharacter

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          description: String.t(),
          image_name: String.t(),
          coords: String.t(),
          coords_type: String.t(),
          status: :free | :occupied,
          private: boolean(),
          parent_id: integer(),
          parent: Map.t(),
          children: list(Map.t()),
          hosts: list(PrivateMapCharacter.t()),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "maps" do
    field :description, :string
    field :image_name, :string
    field :name, :string
    field :coords, :string
    field :coords_type, :string
    field :status, Ecto.Enum, values: [:free, :occupied], virtual: true
    field :private, :boolean, default: false

    belongs_to :parent, Map, foreign_key: :parent_id
    has_many :children, Map, foreign_key: :parent_id
    has_many :hosts, PrivateMapCharacter, foreign_key: :map_id

    timestamps()
  end

  @doc false
  def changeset(map, attrs) do
    map
    |> cast(attrs, [:name, :description, :image_name, :coords, :coords_type, :parent_id, :private])
    |> foreign_key_constraint(:parent_id)
    |> validate_required([:name])
  end
end
