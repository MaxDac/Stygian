defmodule Stygian.TransactionsTest do
  use Stygian.DataCase

  alias Stygian.Transactions

  describe "transactions" do
    alias Ecto.Changeset

    alias Stygian.Characters
    alias Stygian.Transactions.Transaction

    import Stygian.TransactionsFixtures
    import Stygian.CharactersFixtures

    @invalid_attrs %{cigs: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      character1 = character_fixture_complete(%{name: "character1", cigs: 42})
      character2 = character_fixture_complete(%{name: "character2", cigs: 0})
      valid_attrs = %{cigs: 42, sender_id: character1.id, receiver_id: character2.id}

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.cigs == 42
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{cigs: 43}

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.cigs == 43
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, @invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end

    test "perform_transaction/1 correectly moves cigs from one character to the other" do
      character1 = character_fixture_complete(%{name: "character1", cigs: 42})
      character2 = character_fixture_complete(%{name: "character2", cigs: 0})

      assert {:ok, %Transaction{} = transaction} =
               Transactions.perform_transaction(%{
                 "sender_id" => character1.id,
                 "receiver_id" => character2.id,
                 "cigs" => 42
               })

      assert transaction.cigs == 42
      assert transaction.sender_id == character1.id
      assert transaction.receiver_id == character2.id

      assert Characters.get_character!(character1.id).cigs == 0
      assert Characters.get_character!(character2.id).cigs == 42
    end

    test "perform_transaction/1 returns an error if the sender does not have enough cigs" do
      character1 = character_fixture_complete(%{name: "character1", cigs: 40})
      character2 = character_fixture_complete(%{name: "character2", cigs: 0})

      assert {:error, "Non hai abbastanza cigs."} =
               Transactions.perform_transaction(%{
                 "sender_id" => character1.id,
                 "receiver_id" => character2.id,
                 "cigs" => 42
               })

      assert Characters.get_character!(character1.id).cigs == 40
      assert Characters.get_character!(character2.id).cigs == 0
    end

    test "perform_transaction/1 returns an error if the sender does not exist." do
      character2 = character_fixture_complete(%{name: "character2", cigs: 0})

      assert {:error, "Il personaggio non esiste."} =
               Transactions.perform_transaction(%{
                 "sender_id" => 42,
                 "receiver_id" => character2.id,
                 "cigs" => 42
               })

      assert Characters.get_character!(character2.id).cigs == 0
    end

    test "perform_transaction/1 returns an error if the receiver does not exist." do
      character1 = character_fixture_complete(%{name: "character1", cigs: 44})

      assert {:error, %Changeset{} = changeset} =
               Transactions.perform_transaction(%{
                 "sender_id" => character1.id,
                 "receiver_id" => 42,
                 "cigs" => 42
               })

      refute changeset.valid?
      assert %{errors: [receiver_id: {"does not exist", _}]} = changeset
      assert Characters.get_character!(character1.id).cigs == 44
    end
  end
end
