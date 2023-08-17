defmodule Stygian.Maps.PrivateMapCharacter do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Maps.Map
  alias Stygian.Characters.Character

  @type t() :: %{
    id: integer(),
    character_id: integer(),
    character: Character.t(),
    map_id: integer(),
    map: Map.t(),
    host: boolean(),

    inserted_at: NaiveDateTime.t(),
    updated_at: NaiveDateTime.t()
  }

  schema "private_map_rel_characters" do
    belongs_to :character, Character
    belongs_to :map, Map
    field :host, :boolean, default: false 

    timestamps()
  end

  @doc false
  def changeset(private_map_characters, attrs) do
    private_map_characters
    |> cast(attrs, [:character_id, :map_id, :host])
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:map_id)
    |> validate_required([:character_id, :map_id, :host])
  end
end
