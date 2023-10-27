defmodule Stygian.Maps.MapChatsSelectionForm do
  @moduledoc """
  Form to select the chat entries to show at a certain time.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Maps.MapChatsSelectionForm

  @type t() :: %__MODULE__{
          map_id: non_neg_integer(),
          date_from: NaiveDateTime.t(),
          date_to: NaiveDateTime.t()
        }

  embedded_schema do
    field :map_id, :id
    field :date_from, :naive_datetime
    field :date_to, :naive_datetime
  end

  @doc false
  def changeset(%MapChatsSelectionForm{} = map_chats_selection_form, attrs) do
    map_chats_selection_form
    |> cast(attrs, [:map_id, :date_from, :date_to])
    |> validate_required([:map_id, :date_from, :date_to])
  end
end
