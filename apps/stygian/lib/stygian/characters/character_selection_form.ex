defmodule Stygian.Characters.CharacterSelectionForm do
  @moduledoc """
  This embedded schema is used to capture a single character id when needed.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Characters.CharacterSelectionForm

  embedded_schema do
    field :character_id, :id
  end

  @doc false
  def changeset(%CharacterSelectionForm{} = character_selection_form, attrs) do
    character_selection_form
    |> cast(attrs, [:character_id])
    |> validate_required([:character_id])
  end
end
