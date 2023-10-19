defmodule Stygian.Rest.RestActionForm do
  @moduledoc """
  Represents the rest actions selection.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Rest.RestActionForm

  @type t() :: %__MODULE__{
    rest_action_id: integer()
  }

  embedded_schema do 
    field :rest_action_id, :id
  end

  @doc false
  def changeset(%RestActionForm{} = rest_action_form, attrs) do
    rest_action_form
    |> cast(attrs, [:rest_action_id])
    |> validate_required([:rest_action_id])
  end
end
