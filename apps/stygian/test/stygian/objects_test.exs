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

    test "get_object_by_name/1 correctly returns the object with the given name" do
      object_name = "some name"
      object_fixture(%{name: object_name})
      assert object = Objects.get_object_by_name(object_name)
      assert object.name == object_name
    end

    test "get_object_by_name/1 returns nil when the object with the given name does not exist" do
      object_name = "some name"
      assert is_nil Objects.get_object_by_name(object_name)
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
    alias Stygian.Transactions

    import Stygian.CharactersFixtures
    import Stygian.ObjectsFixtures

    @invalid_attrs %{usages: nil}

    test "list_characters_rel_objects/0 returns all characters_rel_objects" do
      character_object = character_object_fixture()
      assert Objects.list_characters_rel_objects() == [character_object]
    end

    test "get_character_object!/1 returns the character_object with given id" do
      character_object = character_object_fixture()

      assert Map.delete(Objects.get_character_object!(character_object.id), :object) ==
               Map.delete(character_object, :object)
    end

    test "get_character_object/1 returns the character_object with given id" do
      character_object = character_object_fixture()

      assert Map.delete(Objects.get_character_object(character_object.id), :object) ==
               Map.delete(character_object, :object)
    end

    test "get_character_object/1 returns nil if the character_object with given id does not exist" do
      assert is_nil(Objects.get_character_object(42))
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

      assert Map.delete(character_object, :object) ==
               Map.delete(Objects.get_character_object!(character_object.id), :object)
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
        "usages" => "42",
        "quantity" => "2"
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
      %{id: object_id_1} = object_fixture(%{name: "object 1"})
      %{id: object_id_2} = object_fixture(%{name: "object 2"})

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

    test "give_object/2 correctly transfers ownership to another character" do
      %{id: character_id_1} = character_fixture()
      %{id: character_id_2} = character_fixture(%{name: "another character"})
      %{id: object_id} = object_fixture()

      character_object =
        character_object_fixture(%{character_id: character_id_1, object_id: object_id})

      assert {:ok, _} = Objects.give_object(character_object, character_id_2)

      assert Enum.empty?(Objects.list_character_objects(character_id_1))
      assert 1 == Enum.count(Objects.list_character_objects(character_id_2))

      [first] = Objects.list_character_objects(character_id_2)

      assert first.character_id == character_id_2
      assert first.object_id == object_id

      assert [transaction] = Transactions.list_transactions()

      assert transaction.character_object_id == character_object.id
      assert transaction.sender_id == character_id_1
      assert transaction.receiver_id == character_id_2
    end

    test "give_object/2 returns an error when the receiver character does not exist" do
      %{id: character_id_1} = character_fixture()
      %{id: object_id} = object_fixture()

      character_object =
        character_object_fixture(%{character_id: character_id_1, object_id: object_id})

      assert {:error, _} = Objects.give_object(character_object, 42)
    end
  end

  describe "object_effects" do
    alias Stygian.Objects.Effect

    import Stygian.ObjectsFixtures
    import Stygian.SkillsFixtures

    @invalid_attrs %{value: nil}

    test "list_object_effects/0 returns all object_effects" do
      effect = effect_fixture()

      assert [strip_effects_fk(effect)] ==
               Objects.list_object_effects()
               |> Enum.map(&strip_effects_fk/1)
    end

    test "list_object_effects/1 returns all the effects of a specific object" do
      %{id: object_id} = object_fixture()
      %{id: skill_id_1} = skill_fixture()
      %{id: skill_id_2} = skill_fixture()

      effect_fixture(%{object_id: object_id, skill_id: skill_id_1})
      effect_fixture(%{object_id: object_id, skill_id: skill_id_2})

      effects = Objects.list_object_effects(object_id)

      assert 2 == Enum.count(effects)

      [first] = Enum.filter(effects, &(&1.skill.id == skill_id_1))
      [second] = Enum.filter(effects, &(&1.skill.id == skill_id_2))

      assert ^object_id = first.object.id
      assert ^object_id = second.object.id

      assert ^skill_id_1 = first.skill.id
      assert ^skill_id_2 = second.skill.id
    end

    test "list_object_effects/1 returns an empty list when no effect is associated with an object" do
      %{id: object_id} = object_fixture()
      assert [] == Objects.list_object_effects(object_id)
    end

    test "get_effect!/1 returns the effect with given id" do
      effect = effect_fixture()
      assert strip_effects_fk(Objects.get_effect!(effect.id)) == strip_effects_fk(effect)
    end

    test "get_effect/2 returns the effect registered for the selected object and skill" do
      %{id: object_id} = object_fixture()
      %{id: skill_id} = skill_fixture()
      %{value: effect_value} = effect_fixture(%{object_id: object_id, skill_id: skill_id})

      assert effect = Objects.get_effect(object_id, skill_id)

      assert effect.object_id == object_id
      assert effect.skill_id == skill_id
      assert effect.value == effect_value
    end

    test "get_effect/2 returns nil if the effect registered for the selected object and skill does not exist" do
      assert is_nil Objects.get_effect(42, 42)
    end

    test "get_complete_effect/1 correctly returns the effect with object and skill preloaded" do
      %{id: effect_id, object_id: object_id, skill_id: skill_id} = effect_fixture()

      effect = Objects.get_complete_effect(effect_id)

      assert not is_nil(effect)
      assert not is_nil(effect.skill)
      assert not is_nil(effect.object)

      assert effect.id == effect_id
      assert effect.object.id == object_id
      assert effect.skill.id == skill_id
    end

    test "create_effect/1 with valid data creates a effect" do
      %{id: object_id} = object_fixture()
      %{id: skill_id} = skill_fixture()

      valid_attrs = %{
        object_id: object_id,
        skill_id: skill_id,
        value: 42
      }

      assert {:ok, %Effect{} = effect} = Objects.create_effect(valid_attrs)
      assert effect.value == 42

      # Verifying that the struct comes with preloaded associations
      assert effect.object.id == object_id
      assert effect.skill.id == skill_id
    end

    test "create_effect/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Objects.create_effect(@invalid_attrs)
    end

    test "update_effect/2 with valid data updates the effect" do
      %{object_id: object_id, skill_id: skill_id} = effect = effect_fixture()
      update_attrs = %{value: 43}

      assert {:ok, %Effect{} = effect} = Objects.update_effect(effect, update_attrs)
      assert effect.value == 43

      # Verifying that the struct comes with preloaded associations
      assert effect.object.id == object_id
      assert effect.skill.id == skill_id
    end

    test "update_effect/2 with invalid data returns error changeset" do
      effect = effect_fixture()
      assert {:error, %Ecto.Changeset{}} = Objects.update_effect(effect, @invalid_attrs)
      assert strip_effects_fk(effect) == strip_effects_fk(Objects.get_effect!(effect.id))
    end

    test "delete_effect/1 deletes the effect" do
      effect = effect_fixture()
      assert {:ok, %Effect{}} = Objects.delete_effect(effect)
      assert_raise Ecto.NoResultsError, fn -> Objects.get_effect!(effect.id) end
    end

    test "change_effect/1 returns a effect changeset" do
      effect = effect_fixture()
      assert %Ecto.Changeset{} = Objects.change_effect(effect)
    end
  end
end
