defmodule Stygian.Characters.CharacterExpForm do
  @moduledoc """
  Embedded schema to manage the experience points increase of a character.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Characters.CharacterExpForm

  @type t() :: %__MODULE__{
          character_id: non_neg_integer(),
          experience: integer()
        }

  embedded_schema do
    field :character_id, :id
    field :experience, :integer
  end

  @doc false
  def changeset(%CharacterExpForm{} = character_exp_form, attrs) do
    character_exp_form
    |> cast(attrs, [:character_id, :experience])
    |> validate_required([:character_id, :experience])
  end
end
