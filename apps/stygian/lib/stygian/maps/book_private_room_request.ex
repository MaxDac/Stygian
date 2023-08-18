defmodule Stygian.Maps.BookPrivateRoomRequest do
  @moduledoc """
  A request changeset for the book private room form.
  """

  defstruct character_1: nil,
            character_2: nil,
            character_3: nil,
            character_4: nil,
            character_5: nil

  @types %{
    character_1: :integer,
    character_2: :integer,
    character_3: :integer,
    character_4: :integer,
    character_5: :integer
  }

  import Ecto.Changeset

  alias Stygian.Maps.BookPrivateRoomRequest

  @type t() :: %__MODULE__{
          character_1: non_neg_integer() | nil,
          character_2: non_neg_integer() | nil,
          character_3: non_neg_integer() | nil,
          character_4: non_neg_integer() | nil,
          character_5: non_neg_integer() | nil
        }

  @spec changeset(request :: BookPrivateRoomRequest.t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(request, attrs \\ %{}) do
    {request, @types}
    |> cast(attrs, [:character_1, :character_2, :character_3, :character_4, :character_5])
    |> validate_required([:character_1])
  end
end
