defmodule Stygian.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        cigs: 42
      })
      |> Stygian.Transactions.create_transaction()

    transaction
  end
end
