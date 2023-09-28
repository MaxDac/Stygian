defmodule Stygian.ObjectsTest do
  use Stygian.DataCase

  alias Stygian.Objects

  describe "objects" do
    alias Stygian.Objects.Object

    import Stygian.ObjectsFixtures

    @invalid_attrs %{description: nil, image_url: nil, name: nil, usages: nil}

    test "list_objects/0 returns all objects" do
      object = object_fixture()
      assert Objects.list_objects() == [object]
    end

    test "get_object!/1 returns the object with given id" do
      object = object_fixture()
      assert Objects.get_object!(object.id) == object
    end

    test "create_object/1 with valid data creates a object" do
      valid_attrs = %{
        description: "some description",
        image_url: "some image_url",
        name: "some name",
        usages: 42
      }

      assert {:ok, %Object{} = object} = Objects.create_object(valid_attrs)
      assert object.description == "some description"
      assert object.image_url == "some image_url"
      assert object.name == "some name"
      assert object.usages == 42
    end

    test "create_object/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Objects.create_object(@invalid_attrs)
    end

    test "update_object/2 with valid data updates the object" do
      object = object_fixture()

      update_attrs = %{
        description: "some updated description",
        image_url: "some updated image_url",
        name: "some updated name",
        usages: 43
      }

      assert {:ok, %Object{} = object} = Objects.update_object(object, update_attrs)
      assert object.description == "some updated description"
      assert object.image_url == "some updated image_url"
      assert object.name == "some updated name"
      assert object.usages == 43
    end

    test "update_object/2 with invalid data returns error changeset" do
      object = object_fixture()
      assert {:error, %Ecto.Changeset{}} = Objects.update_object(object, @invalid_attrs)
      assert object == Objects.get_object!(object.id)
    end

    test "delete_object/1 deletes the object" do
      object = object_fixture()
      assert {:ok, %Object{}} = Objects.delete_object(object)
      assert_raise Ecto.NoResultsError, fn -> Objects.get_object!(object.id) end
    end

    test "change_object/1 returns a object changeset" do
      object = object_fixture()
      assert %Ecto.Changeset{} = Objects.change_object(object)
    end
  end

  describe "characters_rel_objects" do
    alias Stygian.Objects.CharacterObject

    import Stygian.CharactersFixtures
    import Stygian.ObjectsFixtures

    @invalid_attrs %{usages: nil}

    test "list_characters_rel_objects/0 returns all characters_rel_objects" do
      character_object = character_object_fixture()
      assert Objects.list_characters_rel_objects() == [character_object]
    end

    test "get_character_object!/1 returns the character_object with given id" do
      character_object = character_object_fixture()
      assert Objects.get_character_object!(character_object.id) == character_object
    end

    test "create_character_object/1 with valid data creates a character_object" do
      %{id: character_id} = character_fixture()
      %{id: object_id} = object_fixture()

      valid_attrs = %{
        character_id: character_id,
        object_id: object_id,
        usages: 42
      }

      assert {:ok, %CharacterObject{} = character_object} =
               Objects.create_character_object(valid_attrs)

      assert ^character_id = character_object.character_id
      assert ^object_id = character_object.object_id
      assert character_object.usages == 42
    end

    test "create_character_object/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Objects.create_character_object(@invalid_attrs)
    end

    test "update_character_object/2 with valid data updates the character_object" do
      character_object = character_object_fixture()
      update_attrs = %{usages: 43}

      assert {:ok, %CharacterObject{} = character_object} =
               Objects.update_character_object(character_object, update_attrs)

      assert character_object.usages == 43
    end

    test "update_character_object/2 with invalid data returns error changeset" do
      character_object = character_object_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Objects.update_character_object(character_object, @invalid_attrs)

      assert character_object == Objects.get_character_object!(character_object.id)
    end

    test "delete_character_object/1 deletes the character_object" do
      character_object = character_object_fixture()
      assert {:ok, %CharacterObject{}} = Objects.delete_character_object(character_object)

      assert_raise Ecto.NoResultsError, fn ->
        Objects.get_character_object!(character_object.id)
      end
    end

    test "change_character_object/1 returns a character_object changeset" do
      character_object = character_object_fixture()
      assert %Ecto.Changeset{} = Objects.change_character_object(character_object)
    end

    test "create_character_objects/1 adds more than one object to the character inventory" do
      %{id: character_id} = character_fixture()
      %{id: object_id} = object_fixture()

      attrs = %{
        "character_id" => character_id,
        "object_id" => object_id,
        "usages" => 42,
        "quantity" => 2
      }

      assert {:ok, _} = Objects.create_character_objects(attrs)

      [first | _] = character_object = Objects.list_characters_rel_objects()

      assert 2 = Enum.count(character_object)

      assert ^character_id = first.character_id
      assert ^object_id = first.object_id
      assert 42 == first.usages
    end

    test "list_character_objects/1 returns all the character objects" do
      %{id: character_id} = character_fixture()
      %{id: object_id_1} = object_fixture()
      %{id: object_id_2} = object_fixture()

      character_object_fixture(%{character_id: character_id, object_id: object_id_1})
      character_object_fixture(%{character_id: character_id, object_id: object_id_2})

      inventory = Objects.list_character_objects(character_id)

      assert 2 == Enum.count(inventory)

      [first] = Enum.filter(inventory, &(&1.object.id == object_id_1))
      [second] = Enum.filter(inventory, &(&1.object.id == object_id_2))

      assert ^character_id = first.character_id
      assert ^character_id = second.character_id

      assert ^object_id_1 = first.object.id
      assert ^object_id_2 = second.object.id
    end
  end
end
