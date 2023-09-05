defmodule Stygian.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :cigs, :integer
    field :sender_id, :id
    field :receiver_id, :id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:cigs])
    |> validate_required([:cigs])
  end
end
