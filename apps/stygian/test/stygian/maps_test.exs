defmodule Stygian.MapsTest do
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

      assert [child_map_1, child_map_2] == Maps.list_child_maps(map)
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
  end
end
