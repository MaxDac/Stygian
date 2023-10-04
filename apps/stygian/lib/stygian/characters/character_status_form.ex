defmodule Stygian.Characters.CharacterStatusForm do
  @moduledoc """
  Embedded schema to handle the character status form. 
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Characters.CharacterStatusForm

  @type t() :: %__MODULE__{
          character_id: non_neg_integer(),
          health: integer(),
          sanity: integer()
        }

  embedded_schema do
    field :character_id, :id
    field :health, :integer
    field :sanity, :integer
  end

  @doc false
  def changeset(%CharacterStatusForm{} = character_status_form, attrs) do
    character_status_form
    |> cast(attrs, [:character_id, :health, :sanity])
    |> validate_required([:character_id, :health, :sanity])
  end
end
