defmodule Stygian.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Transactions` context.
  """

  import Stygian.CharactersFixtures

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    sender = character_fixture(%{name: "sender#{System.unique_integer()}"})
    receiver = character_fixture(%{name: "receiver#{System.unique_integer()}"})

    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        cigs: 42,
        sender_id: sender.id,
        receiver_id: receiver.id
      })
      |> Stygian.Transactions.create_transaction()

    transaction
  end
end
