defmodule Stygian.MapsTest do
  alias Stygian.Characters
  use Stygian.DataCase

  alias Stygian.Maps

  describe "maps" do
    import Stygian.MapsFixtures

    @invalid_attrs %{description: nil, image_name: nil, name: nil}

    test "list_maps/0 returns all maps" do
      map = map_fixture()
      assert Maps.list_maps() == [map]
    end

    test "get_map!/1 returns the map with given id" do
      map = map_fixture()
      assert Maps.get_map!(map.id) == map
    end

    test "get_map/1 returns the map with given id" do
      map = map_fixture()
      assert Maps.get_map(map.id) == map
    end

    test "get_map/1 returns nil if the map does not exist" do
      assert Maps.get_map(1) == nil
    end

    test "get_map_by_name/1 returns the map with given name" do
      map = map_fixture()
      assert Maps.get_map_by_name(map.name) == map
    end

    test "get_map_by_name/1 returns nil when the map does not exist" do
      assert Maps.get_map_by_name("some name") == nil
    end

    test "create_map/1 with valid data creates a map" do
      valid_attrs = %{
        description: "some description",
        image_name: "some image_name",
        name: "some name"
      }

      assert {:ok, %Stygian.Maps.Map{} = map} = Maps.create_map(valid_attrs)
      assert map.description == "some description"
      assert map.image_name == "some image_name"
      assert map.name == "some name"
    end

    test "create_map/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maps.create_map(@invalid_attrs)
    end

    test "update_map/2 with valid data updates the map" do
      map = map_fixture()

      update_attrs = %{
        description: "some updated description",
        image_name: "some updated image_name",
        name: "some updated name"
      }

      assert {:ok, %Stygian.Maps.Map{} = map} = Maps.update_map(map, update_attrs)
      assert map.description == "some updated description"
      assert map.image_name == "some updated image_name"
      assert map.name == "some updated name"
    end

    test "update_map/2 with invalid data returns error changeset" do
      map = map_fixture()
      assert {:error, %Ecto.Changeset{}} = Maps.update_map(map, @invalid_attrs)
      assert map == Maps.get_map!(map.id)
    end

    test "delete_map/1 deletes the map" do
      map = map_fixture()
      assert {:ok, %Stygian.Maps.Map{}} = Maps.delete_map(map)
      assert_raise Ecto.NoResultsError, fn -> Maps.get_map!(map.id) end
    end

    test "change_map/1 returns a map changeset" do
      map = map_fixture()
      assert %Ecto.Changeset{} = Maps.change_map(map)
    end

    test "list_parent_maps/0 returns all parent maps" do
      map = map_fixture()
      _ = map_fixture(%{name: "Child", parent_id: map.id})
      assert Maps.list_parent_maps() == [map]
    end

    test "list_child_maps/1 returns all the child maps from a given parent" do
      map = map_fixture()
      child_map_1 = map_fixture(%{name: "Child 1", parent_id: map.id})
      child_map_2 = map_fixture(%{name: "Child 2", parent_id: map.id})

      assert maps = Maps.list_child_maps(map)
      assert Enum.member?(maps, child_map_1)
      assert Enum.member?(maps, child_map_2)
    end

    test "get_map_with_children/1 returns the map with the children" do
      %{id: parent_id} = map_fixture()
      child = map_fixture(%{name: "child", parent_id: parent_id})
      parent_map = Maps.get_map_with_children(parent_id)
      assert parent_id == parent_map.id
      assert [child] == parent_map.children
    end
  end

  describe "chats" do
    alias Stygian.Maps.Chat

    import Stygian.MapsFixtures
    import Stygian.CharactersFixtures

    @invalid_attrs %{text: nil, type: nil}

    test "list_chats/0 returns all chats" do
      chat = chat_fixture() |> Map.delete(:character)
      assert Maps.list_chats() |> Enum.map(&Map.delete(&1, :character)) == [chat]
    end

    test "get_chat!/1 returns the chat with given id" do
      chat = chat_fixture() |> Map.delete(:character)
      assert Maps.get_chat!(chat.id) |> Map.delete(:character) == chat
    end

    test "list_map_chats/2 returns an empty list if no chat exist for the given map" do
      map = map_fixture()
      assert [] == Maps.list_map_chats(map.id)
    end

    test "list_map_chats/2 returns the chat entry previously inserted" do
      chat = chat_fixture()

      assert [chat |> Map.delete(:character)] ==
               Maps.list_map_chats(chat.map_id)
               |> Enum.map(&Map.delete(&1, :character))
    end

    test "list_map_chats/2 returns the chat entry with the character preloaded" do
      chat = chat_fixture()
      assert [found] = Maps.list_map_chats(chat.map_id)
      assert found.character.id == chat.character_id
      assert not is_nil(found.character.name)
    end

    test "list_map_chats/2 does not return the chat entry previously inserted if prior to the limit" do
      # Setting the limit in the future, because Ecto make it difficult to modify inserted_at and updated_at fields
      limit =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(100, :minute)

      chat = chat_fixture()
      assert [] == Maps.list_map_chats(chat.map_id, limit)
    end

    test "create_chat/1 with valid data creates a chat" do
      %{id: character_id} = character_fixture()
      %{id: map_id} = map_fixture()

      valid_attrs = %{
        text: "some text",
        type: :master,
        character_id: character_id,
        map_id: map_id
      }

      assert {:ok, %Chat{} = chat} = Maps.create_chat(valid_attrs)
      assert chat.text == "some text"
      assert chat.type == :master
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maps.create_chat(@invalid_attrs)
    end

    test "create_chat/1 with valid data creates a chat and preloads the character" do
      %{id: character_id, name: character_name} = character_fixture()
      %{id: map_id} = map_fixture()

      valid_attrs = %{
        text: "some text",
        type: :master,
        character_id: character_id,
        map_id: map_id
      }

      assert {:ok, %Chat{} = chat} = Maps.create_chat(valid_attrs)
      assert chat.text == "some text"
      assert chat.type == :master
      assert chat.character.id == character_id
      assert chat.character.name == character_name
    end

    test "update_chat/2 with valid data updates the chat" do
      chat = chat_fixture()
      update_attrs = %{text: "some updated text", type: :dices}

      assert {:ok, %Chat{} = chat} = Maps.update_chat(chat, update_attrs)
      assert chat.text == "some updated text"
      assert chat.type == :dices
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture() |> Map.delete(:character)
      assert {:error, %Ecto.Changeset{}} = Maps.update_chat(chat, @invalid_attrs)
      assert chat == Maps.get_chat!(chat.id) |> Map.delete(:character)
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{}} = Maps.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Maps.get_chat!(chat.id) end
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = Maps.change_chat(chat)
    end

    test "list_map_chats_logs/1 returns the right chat logs for the given filters" do
      character1 = character_fixture(%{name: "Character 1"})
      character2 = character_fixture(%{name: "Character 2"})

      map1 = map_fixture(%{name: "Map 1"})
      map2 = map_fixture(%{name: "Map 2"})

      yesterday = NaiveDateTime.add(NaiveDateTime.utc_now(), -1, :day)
      one_hour_ago = NaiveDateTime.add(NaiveDateTime.utc_now(), -1, :hour)
      ten_minute_ago = NaiveDateTime.add(NaiveDateTime.utc_now(), -10, :minute)
      one_minute_ago = NaiveDateTime.add(NaiveDateTime.utc_now(), -1, :minute)
      now = NaiveDateTime.utc_now()

      chat_fixture(%{character_id: character1.id, map_id: map1.id, updated_at: yesterday, inserted_at: yesterday})
      chat_fixture(%{character_id: character2.id, map_id: map1.id, updated_at: one_hour_ago, inserted_at: one_hour_ago})
      entry3 = chat_fixture(%{character_id: character2.id, map_id: map1.id, updated_at: ten_minute_ago, inserted_at: ten_minute_ago})
      entry4 = chat_fixture(%{character_id: character1.id, map_id: map1.id, updated_at: one_minute_ago, inserted_at: one_minute_ago})
      entry5 = chat_fixture(%{character_id: character2.id, map_id: map1.id, updated_at: now, inserted_at: now})

      _entry_on_another_chat = chat_fixture(%{character_id: character1.id, map_id: map2.id, inserted_at: now})

      logs = Maps.list_map_chats_logs(%{map_id: map1.id, date_from: ten_minute_ago, date_to: now})

      assert 3 == Enum.count(logs)

      assert Enum.any?(logs, &(&1.id == entry3.id))
      assert Enum.any?(logs, &(&1.id == entry4.id))
      assert Enum.any?(logs, &(&1.id == entry5.id))
    end
  end

  describe "Dice throw chat creation" do
    alias Stygian.Maps

    import Stygian.MapsFixtures
    import Stygian.SkillsFixtures
    import Stygian.CharactersFixtures

    setup do
      map = map_fixture()
      character = character_fixture_complete()

      skill1 = skill_fixture(%{name: "skill1"})
      skill2 = skill_fixture(%{name: "skill2"})

      character_skill_1 =
        character_skill_fixture(%{character_id: character.id, skill_id: skill1.id, value: 5})
        |> Repo.preload(:skill)

      character_skill_2 =
        character_skill_fixture(%{character_id: character.id, skill_id: skill2.id, value: 2})
        |> Repo.preload(:skill)

      %{
        map: map,
        character: character,
        skill1: skill1,
        skill2: skill2,
        character_skill_1: character_skill_1,
        character_skill_2: character_skill_2
      }
    end

    test "create_dice_throw_chat_entry/2 Returns a critical failure", %{
      map: map,
      character: character,
      skill1: skill1,
      skill2: skill2,
      character_skill_1: character_skill_1,
      character_skill_2: character_skill_2
    } do
      assert {:ok, chat} =
               Maps.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 3,
                   difficulty: 18
                 },
                 fn _ -> 1 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} + 3 con Diff. 18 ottenendo un fallimento critico (10 + 1)."
    end

    test "create_dice_throw_chat_entry/2 Returns a critical success", %{
      map: map,
      character: character,
      skill1: skill1,
      skill2: skill2,
      character_skill_1: character_skill_1,
      character_skill_2: character_skill_2
    } do
      assert {:ok, chat} =
               Maps.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 3,
                   difficulty: 18
                 },
                 fn _ -> 20 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} + 3 con Diff. 18 ottenendo un successo critico (10 + 20)."
    end

    test "create_dice_throw_chat_entry/2 Returns a failure", %{
      map: map,
      character: character,
      skill1: skill1,
      skill2: skill2,
      character_skill_1: character_skill_1,
      character_skill_2: character_skill_2
    } do
      assert {:ok, chat} =
               Maps.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 3,
                   difficulty: 18
                 },
                 fn _ -> 5 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} + 3 con Diff. 18 ottenendo un fallimento (10 + 5)."
    end

    test "create_dice_throw_chat_entry/2 returns a success", %{
      map: map,
      character: character,
      skill1: skill1,
      skill2: skill2,
      character_skill_1: character_skill_1,
      character_skill_2: character_skill_2
    } do
      assert {:ok, chat} =
               Maps.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 3,
                   difficulty: 10
                 },
                 fn _ -> 5 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} + 3 con Diff. 10 ottenendo un successo (10 + 5)."
    end

    test "create_dice_throw_chat_entry/2 returns a failure for the modifier", %{
      map: map,
      character: character,
      skill1: skill1,
      skill2: skill2,
      character_skill_1: character_skill_1,
      character_skill_2: character_skill_2
    } do
      assert {:ok, chat} =
               Maps.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: -1,
                   difficulty: 18
                 },
                 fn _ -> 7 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} - 1 con Diff. 18 ottenendo un fallimento (6 + 7)."
    end

    test "create_dice_throw_chat_entry/2 returns a success when the result equals the difficulty",
         %{
           map: map,
           character: character,
           skill1: skill1,
           skill2: skill2,
           character_skill_1: character_skill_1,
           character_skill_2: character_skill_2
         } do
      assert {:ok, chat} =
               Maps.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 0,
                   difficulty: 10
                 },
                 fn _ -> 7 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} con Diff. 10 ottenendo un successo (7 + 7)."
    end

    test "create_dice_throw_chat_entry/2 fails because the character is fatigued",
         %{
           map: map,
           character: character,
           skill1: skill1,
           skill2: skill2,
           character_skill_1: character_skill_1,
           character_skill_2: character_skill_2
         } do
      {:ok, character} = Characters.update_character(character, %{fatigue: 100})

      assert {:ok, chat} =
               Maps.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 0,
                   difficulty: 12
                 },
                 fn _ -> 7 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} con Diff. 12 ottenendo un fallimento (4 + 7)."
    end
  end

  describe "Private maps" do
    alias Stygian.Maps

    import Stygian.MapsFixtures
    import Stygian.CharactersFixtures

    test "list_private_rooms/0 lists all the private rooms" do
      map_fixture(%{name: "room1", private: true})
      map_fixture(%{name: "room2", private: true})
      map_fixture(%{name: "room3", private: false})

      rooms = Maps.list_private_rooms()
      assert 2 == Enum.count(rooms)
      assert Enum.any?(rooms, &(&1.name == "room1"))
      assert Enum.any?(rooms, &(&1.name == "room2"))
    end

    test "list_private_rooms/0 lists all the private rooms with the correct status" do
      %{id: map_id_1} = map_fixture(%{name: "room1", private: true})
      map_fixture(%{name: "room2", private: true})
      map_fixture(%{name: "room3", private: false})

      private_map_character_fixture(%{
        map_id: map_id_1,
        host: true
      })

      rooms = Maps.list_private_rooms()
      assert 2 == Enum.count(rooms)
      assert Enum.any?(rooms, &(&1.name == "room1" && &1.status == :occupied))
      assert Enum.any?(rooms, &(&1.name == "room2" && &1.status == :free))
    end

    test "list_private_rooms/0 returns an empty list when no private maps exist" do
      map_fixture(%{name: "room3", private: false})
      assert [] = Maps.list_private_rooms()
    end

    test "list_private_map_characters/1 returns the list of characters allowed into the private room" do
      %{id: map_id} = map_fixture()

      %{id: character_id_1} = character_fixture(%{name: "Name Whatever 1"})
      %{id: character_id_2} = character_fixture(%{name: "Name Whatever 2"})
      %{id: character_id_3} = character_fixture(%{name: "Name Whatever 3"})

      private_map_character_fixture(%{map_id: map_id, character_id: character_id_1})
      private_map_character_fixture(%{map_id: map_id, character_id: character_id_2})
      private_map_character_fixture(%{map_id: map_id, character_id: character_id_3})

      character_list = Maps.list_private_map_characters(map_id)

      assert 3 = Enum.count(character_list)
      assert Enum.any?(character_list, &(&1.character_id == character_id_1))
      assert Enum.any?(character_list, &(&1.character_id == character_id_2))
      assert Enum.any?(character_list, &(&1.character_id == character_id_3))
    end

    test "list_private_map_characters/1 returns an empty list when the private map is free" do
      %{id: map_id} = map_fixture()
      character_list = Maps.list_private_map_characters(map_id)
      assert 0 = Enum.count(character_list)
    end

    test "character_is_already_host?/1 returns false if the character is not an host" do
      %{id: character_id} = character_fixture()
      refute Maps.character_is_already_host?(character_id)
    end

    test "character_is_already_host?/1 returns true if the character is an host" do
      %{id: character_id_1} = character_fixture(%{name: "Some character 1"})
      %{id: character_id_2} = character_fixture(%{name: "Some character 2"})

      %{id: map_id} = map_fixture(%{private: true})

      assert :ok = Maps.book_private_room(map_id, character_id_1, [character_id_2])
      assert Maps.character_is_already_host?(character_id_1)
    end

    test "book_private_room/3 fails when the host is null" do
      assert {:error, %Ecto.Changeset{}} = Maps.book_private_room(1, nil, [1, 2])
    end

    test "book_private_room/3 fails when the chracter id list is empty" do
      assert {:error, %Ecto.Changeset{}} = Maps.book_private_room(1, 1, [])
    end

    test "book_private_room/3 fails if the room is not private" do
      %{id: character_id_1} = character_fixture(%{name: "Some Name 1"})
      %{id: character_id_2} = character_fixture(%{name: "Some Name 2"})
      %{id: character_id_3} = character_fixture(%{name: "Some Name 3"})

      %{id: map_id} = map_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maps.book_private_room(map_id, character_id_1, [character_id_2, character_id_3])
    end

    test "book_private_room/3 fails if the character is already host" do
      %{id: character_id_1} = character_fixture(%{name: "Some Name 1"})
      %{id: character_id_2} = character_fixture(%{name: "Some Name 2"})

      %{id: map_id_1} = map_fixture(%{name: "map1", private: true})
      %{id: map_id_2} = map_fixture(%{name: "map2", private: true})

      assert :ok = Maps.book_private_room(map_id_1, character_id_1, [character_id_2])

      assert {:error, _changeset} =
               Maps.book_private_room(map_id_2, character_id_1, [character_id_2])
    end

    test "book_private_room/3 insert all the characters in the private room" do
      %{id: character_id_1} = character_fixture(%{name: "Some Name 1"})
      %{id: character_id_2} = character_fixture(%{name: "Some Name 2"})
      %{id: character_id_3} = character_fixture(%{name: "Some Name 3"})

      %{id: map_id} = map_fixture(%{private: true})

      assert :ok =
               Maps.book_private_room(map_id, character_id_1, [character_id_2, character_id_3])

      character_list = Maps.list_private_map_characters(map_id)

      assert 3 = Enum.count(character_list)
      assert Enum.any?(character_list, &(&1.character_id == character_id_1 && &1.host))
      assert Enum.any?(character_list, &(&1.character_id == character_id_2 && not &1.host))
      assert Enum.any?(character_list, &(&1.character_id == character_id_3 && not &1.host))
    end

    test "add_character_guest/2 returns an error if the room is not booked" do
      %{id: character_id} = character_fixture()
      %{id: map_id} = map_fixture()

      assert {:error, %Ecto.Changeset{}} = Maps.add_character_guest(map_id, character_id)
    end

    test "add_character_guest/2 adds the guest to the private room" do
      %{id: character_id_1} = character_fixture(%{name: "Some Name 1"})
      %{id: character_id_2} = character_fixture(%{name: "Some Name 2"})
      %{id: character_id_3} = character_fixture(%{name: "Some Name 3"})

      %{id: map_id} = map_fixture(%{private: true})

      Maps.book_private_room(map_id, character_id_1, [character_id_2])

      assert {:ok, %Stygian.Maps.PrivateMapCharacter{}} =
               Maps.add_character_guest(map_id, character_id_3)
    end
  end
end
