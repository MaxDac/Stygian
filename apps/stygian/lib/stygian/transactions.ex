defmodule Stygian.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Stygian.Repo

  alias Ecto.Changeset

  alias Stygian.Characters
  alias Stygian.Transactions.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Performs the transaction by removing the cigs from the sender and adding them to the receiver.
  """
  @spec perform_transaction(map()) ::
          {:ok, Transaction.t()} | {:error, Changeset.t()} | {:error, String.t()}
  def perform_transaction(%{"cigs" => cigs} = attrs) when is_binary(cigs),
    do: perform_transaction(attrs |> Map.put("cigs", String.to_integer(cigs)))

  def perform_transaction(
        %{"sender_id" => sender_id, "receiver_id" => receiver_id, "cigs" => cigs} = attrs
      ) do
    with :ok <- check_sender_amount(sender_id, cigs),
         {:ok, transaction} <-
           create_transaction(attrs) do
      sender = Characters.get_character!(sender_id)
      receiver = Characters.get_character!(receiver_id)

      sender_cigs = sender.cigs - cigs
      receiver_cigs = receiver.cigs + cigs

      sender_changeset = Characters.change_cigs(sender, %{cigs: sender_cigs})
      receiver_changeset = Characters.change_cigs(receiver, %{cigs: receiver_cigs})

      case Repo.transaction(fn ->
             Repo.update!(sender_changeset)
             Repo.update!(receiver_changeset)
             create_transaction(%{sender_id: sender_id, receiver_id: receiver_id, cigs: cigs})
           end) do
        {:ok, _} ->
          {:ok, transaction}

        {:error, _} ->
          delete_transaction(transaction)
          {:error, "Errore durante la transazione."}
      end
    end
  end

  defp check_sender_amount(sender_id, amount) do
    case Characters.get_character(sender_id) do
      %{cigs: cigs} when cigs >= amount ->
        :ok

      nil ->
        {:error, "Il personaggio non esiste."}

      _ ->
        {:error, "Non hai abbastanza cigs."}
    end
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
