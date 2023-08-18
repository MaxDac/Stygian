defmodule Stygian.Characters.NpcCreationRequest do
  @moduledoc """
  A request to create an NPC.
  """

  defstruct name: nil, avatar: nil, attributes: []

  @types %{
    name: :string,
    avatar: :string,
    attributes: :list
  }

  import Ecto.Changeset

  alias Stygian.Characters.NpcCreationRequest
  alias Stygian.Skills.Skill

  @type t() :: %__MODULE__{
          name: String.t(),
          avatar: String.t(),
          attributes: list(Skill.t())
  }

  @spec changeset(NpcCreationRequest.t(), map()) :: Ecto.Changeset.t()
  def changeset(request, attrs \\ %{}) do
    {request, @types}
    |> cast(attrs, [:name, :avatar, :attributes])
    |> validate_required([:name, :attributes])
  end
end
