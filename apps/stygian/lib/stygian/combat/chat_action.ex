defmodule Stygian.Combat.ChatAction do
  @moduledoc """
  The chat action created from the dice form.
  This action will be resolved in the chat screen, from a special chat entry.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Characters.Character
  alias Stygian.Combat.Action

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          resolved: boolean(),
          accepted: boolean(),
          action_id: non_neg_integer(),
          attacker_id: non_neg_integer(),
          defender_id: non_neg_integer(),
          action: Action.t(),
          attacker: Character.t(),
          defender: Character.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "chat_actions" do
    field :resolved, :boolean, default: false
    field :accepted, :boolean, default: false

    belongs_to :action, Action
    belongs_to :attacker, Character
    belongs_to :defender, Character

    timestamps()
  end

  @doc false
  def changeset(chat_action, attrs) do
    chat_action
    |> cast(attrs, [:resolved, :accepted, :action_id, :attacker_id, :defender_id])
    |> validate_required([:resolved, :accepted, :action_id, :attacker_id, :defender_id])
    |> foreign_key_constraint(:action_id)
    |> foreign_key_constraint(:attacker_id)
    |> foreign_key_constraint(:defender_id)
  end
end
