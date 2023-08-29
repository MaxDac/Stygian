defmodule Stygian.Characters.NpcCreationRequest do
  @moduledoc """
  A request to create an NPC.
  """

  defstruct name: nil, avatar: nil, small_avatar: nil, attributes: []

  @types %{
    name: :string,
    avatar: :string,
    small_avatar: :string,
    attributes: :list
  }

  import Ecto.Changeset

  alias Stygian.Characters.NpcCreationRequest
  alias Stygian.Skills.Skill

  @type t() :: %__MODULE__{
          name: String.t(),
          avatar: String.t(),
          small_avatar: String.t(),
          attributes: list(Skill.t())
        }

  @spec changeset(NpcCreationRequest.t(), map()) :: Ecto.Changeset.t()
  def changeset(request, attrs \\ %{}) do
    {request, @types}
    |> cast(attrs, [:name, :avatar, :small_avatar, :attributes])
    |> validate_required([:name, :avatar, :attributes])
  end
end
