defmodule Stygian.Transactions.Transaction do
  @moduledoc """
  Schema for a transaction.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Characters.Character

  @type t() :: %__MODULE__{
    id: integer(),
    cigs: integer(),
    sender_id: integer(),
    receiver_id: integer(),

    sender: Character.t(),
    receiver: Character.t(),

    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  schema "transactions" do
    field :cigs, :integer

    belongs_to :sender, Stygian.Characters.Character
    belongs_to :receiver, Stygian.Characters.Character

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:cigs, :sender_id, :receiver_id])
    |> validate_required([:cigs, :sender_id, :receiver_id])
    |> foreign_key_constraint(:sender_id)
    |> foreign_key_constraint(:receiver_id)
  end
end
