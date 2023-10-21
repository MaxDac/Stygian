defmodule Stygian.RestTest do
  use Stygian.DataCase

  alias Stygian.Rest

  describe "rest_actions" do
    alias Stygian.Rest.RestAction

    import Stygian.RestFixtures

    @invalid_attrs %{name: nil, description: nil, health: nil, sanity: nil, research_points: nil}

    test "list_rest_actions/0 returns all rest_actions" do
      rest_action = rest_action_fixture()
      assert Rest.list_rest_actions() == [rest_action]
    end

    test "get_rest_action!/1 returns the rest_action with given id" do
      rest_action = rest_action_fixture()
      assert Rest.get_rest_action!(rest_action.id) == rest_action
    end

    test "get_rest_action_by_name/1 returns the rest action by its name" do
      rest_action = rest_action_fixture()
      assert Rest.get_rest_action_by_name(rest_action.name) == rest_action
    end

    test "get_rest_action_by_name/1 returns nil when no rest action with the name exists" do
      assert is_nil(Rest.get_rest_action_by_name("some name"))
    end

    test "create_rest_action/1 with valid data creates a rest_action" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        health: 42,
        sanity: 42,
        research_points: 42,
        slots: 1
      }

      assert {:ok, %RestAction{} = rest_action} = Rest.create_rest_action(valid_attrs)
      assert rest_action.name == "some name"
      assert rest_action.description == "some description"
      assert rest_action.health == 42
      assert rest_action.sanity == 42
      assert rest_action.research_points == 42
    end

    test "create_rest_action/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rest.create_rest_action(@invalid_attrs)
    end

    test "update_rest_action/2 with valid data updates the rest_action" do
      rest_action = rest_action_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        health: 43,
        sanity: 43,
        research_points: 43
      }

      assert {:ok, %RestAction{} = rest_action} =
               Rest.update_rest_action(rest_action, update_attrs)

      assert rest_action.name == "some updated name"
      assert rest_action.description == "some updated description"
      assert rest_action.health == 43
      assert rest_action.sanity == 43
      assert rest_action.research_points == 43
    end

    test "update_rest_action/2 with invalid data returns error changeset" do
      rest_action = rest_action_fixture()
      assert {:error, %Ecto.Changeset{}} = Rest.update_rest_action(rest_action, @invalid_attrs)
      assert rest_action == Rest.get_rest_action!(rest_action.id)
    end

    test "delete_rest_action/1 deletes the rest_action" do
      rest_action = rest_action_fixture()
      assert {:ok, %RestAction{}} = Rest.delete_rest_action(rest_action)
      assert_raise Ecto.NoResultsError, fn -> Rest.get_rest_action!(rest_action.id) end
    end

    test "change_rest_action/1 returns a rest_action changeset" do
      rest_action = rest_action_fixture()
      assert %Ecto.Changeset{} = Rest.change_rest_action(rest_action)
    end
  end

  describe "Character rest" do
    alias Stygian.Characters
    alias Stygian.Characters.Character

    import Stygian.CharactersFixtures

    test "rest_character/1 correctly restored lost sanity to the character" do
      character = character_fixture_complete(%{lost_sanity: 6, cigs: 10})

      assert {:ok, %Character{} = character} = Rest.rest_character(character)

      assert character.lost_sanity == 1
      assert character.cigs == 5
    end

    test "rest_character/1 correctly restored lost sanity to the character, but only the lost one" do
      character = character_fixture_complete(%{lost_sanity: 2, cigs: 10})

      assert {:ok, %Character{} = character} = Rest.rest_character(character)

      assert character.lost_sanity == 0
      assert character.cigs == 5
    end

    test "rest_character/1 does not restore sanity if sanity was already at its maximum, but subtracts the cigs" do
      character = character_fixture_complete(%{lost_sanity: 0, cigs: 10})

      assert {:ok, %Character{} = character} = Rest.rest_character(character)

      assert character.lost_sanity == 0
      assert character.cigs == 5
    end

    test "rest_character/1 does not restore the character if 24 hours haven't passed" do
      character =
        character_fixture_complete(%{
          lost_sanity: 6,
          cigs: 10,
          rest_timer: NaiveDateTime.utc_now()
        })

      assert {:error, "Non puoi ancora far riposare il personaggio."} =
               Rest.rest_character(character)

      character = Characters.get_character!(character.id)
      assert character.lost_sanity == 6
      assert character.cigs == 10
    end

    test "rest_character/1 does not restore the character if it doesn't have enough cigs" do
      character =
        character_fixture_complete(%{
          lost_sanity: 6,
          cigs: 4,
          rest_timer: NaiveDateTime.utc_now()
        })

      assert {:error, "Non hai abbastanza sigarette per poter pagare l'albergo."} =
               Rest.rest_character(character)

      character = Characters.get_character!(character.id)
      assert character.lost_sanity == 6
      assert character.cigs == 4
    end

    test "rest_character/1 does not restore the character if it doesn't have enough cigs with custom cost" do
      character =
        character_fixture_complete(%{
          lost_sanity: 6,
          cigs: 7,
          rest_timer: NaiveDateTime.utc_now()
        })

      assert {:error, "Non hai abbastanza sigarette per poter pagare l'albergo."} =
               Rest.rest_character(character, 20)

      character = Characters.get_character!(character.id)
      assert character.lost_sanity == 6
      assert character.cigs == 7
    end
  end
end
