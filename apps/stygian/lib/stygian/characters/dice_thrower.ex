defmodule Stygian.Characters.DiceThrower do
  @moduledoc """
  Schemaless form changeset
  """

  defstruct attribute_id: nil, skill_id: nil, modifier: nil, difficulty: nil

  @types %{
    attribute_id: :integer,
    skill_id: :integer,
    modifier: :integer,
    difficulty: :integer
  }

  import Ecto.Changeset

  alias Stygian.Characters.DiceThrower

  @type t() :: %__MODULE__{
          attribute_id: non_neg_integer() | nil,
          skill_id: non_neg_integer() | nil,
          modifier: non_neg_integer() | nil,
          difficulty: non_neg_integer() | nil
        }

  @spec changeset(DiceThrower.t(), map()) :: Ecto.Changeset.t()
  def changeset(dice_throw, attrs \\ %{}) do
    {dice_throw, @types}
    |> cast(attrs, [:attribute_id, :skill_id, :modifier, :difficulty])
    |> validate_required([:attribute_id, :skill_id, :difficulty])
  end
end
