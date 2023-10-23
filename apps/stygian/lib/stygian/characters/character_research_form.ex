defmodule Stygian.Characters.CharacterResearchForm do
  @moduledoc """
  Form to handle the assignation of research points.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Characters.CharacterResearchForm

  @type t() :: %__MODULE__{
          character_id: non_neg_integer(),
          research_points: non_neg_integer()
        }

  embedded_schema do 
    field :character_id, :id
    field :research_points, :integer
  end

  @doc false
  def changeset(%CharacterResearchForm{} = character_research_form, attrs) do
    character_research_form
    |> cast(attrs, [:character_id, :research_points])
    |> validate_required([:character_id, :research_points])
  end
end
