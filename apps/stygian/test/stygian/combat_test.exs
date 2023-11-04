defmodule Stygian.CombatTest do
  use Stygian.DataCase

  alias Stygian.Combat

  describe "combat_actions" do
    alias Stygian.Combat.Action

    import Stygian.CombatFixtures
    import Stygian.SkillsFixtures

    @invalid_attrs %{name: nil, description: nil, minimum_skill_value: nil}

    test "list_combat_actions/0 returns all combat_actions" do
      action = action_fixture()
      assert Combat.list_combat_actions() == [action]
    end

    test "get_action!/1 returns the action with given id" do
      action = action_fixture()
      assert Combat.get_action!(action.id) == action
    end

    test "get_action_by_name/1 returns the action with the given name" do
      action = action_fixture()
      got_action = Combat.get_action_by_name(action.name)

      refute is_nil(got_action)
      assert action.description == got_action.description
    end

    test "get_action_by_name/1 returns nil when action with that name does not exist" do
      %{name: name} = action_fixture()
      assert is_nil(Combat.get_action_by_name("#{name} other"))
    end

    test "create_action/1 with valid data creates a action" do
      %{id: attribute_id} = skill_fixture()
      %{id: weapon_type_id} = weapon_type_fixture()

      valid_attrs = %{
        name: "some name",
        description: "some description",
        minimum_skill_value: 42,
        attack_attribute_id: attribute_id,
        attack_skill_id: attribute_id,
        defence_attribute_id: attribute_id,
        defence_skill_id: attribute_id,
        weapon_type_id: weapon_type_id
      }

      assert {:ok, %Action{} = action} = Combat.create_action(valid_attrs)
      assert action.name == "some name"
      assert action.description == "some description"
      assert action.minimum_skill_value == 42
    end

    test "create_action/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Combat.create_action(@invalid_attrs)
    end

    test "update_action/2 with valid data updates the action" do
      action = action_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        minimum_skill_value: 43
      }

      assert {:ok, %Action{} = action} = Combat.update_action(action, update_attrs)
      assert action.name == "some updated name"
      assert action.description == "some updated description"
      assert action.minimum_skill_value == 43
    end

    test "update_action/2 with invalid data returns error changeset" do
      action = action_fixture()
      assert {:error, %Ecto.Changeset{}} = Combat.update_action(action, @invalid_attrs)
      assert action == Combat.get_action!(action.id)
    end

    test "delete_action/1 deletes the action" do
      action = action_fixture()
      assert {:ok, %Action{}} = Combat.delete_action(action)
      assert_raise Ecto.NoResultsError, fn -> Combat.get_action!(action.id) end
    end

    test "change_action/1 returns a action changeset" do
      action = action_fixture()
      assert %Ecto.Changeset{} = Combat.change_action(action)
    end
  end

  describe "weapon_types" do
    alias Stygian.Combat.WeaponType

    import Stygian.CombatFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_weapon_types/0 returns all weapon_types" do
      weapon_type = weapon_type_fixture()
      assert Combat.list_weapon_types() == [weapon_type]
    end

    test "get_weapon_type!/1 returns the weapon_type with given id" do
      weapon_type = weapon_type_fixture()
      assert Combat.get_weapon_type!(weapon_type.id) == weapon_type
    end

    test "create_weapon_type/1 with valid data creates a weapon_type" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %WeaponType{} = weapon_type} = Combat.create_weapon_type(valid_attrs)
      assert weapon_type.name == "some name"
      assert weapon_type.description == "some description"
    end

    test "create_weapon_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Combat.create_weapon_type(@invalid_attrs)
    end

    test "update_weapon_type/2 with valid data updates the weapon_type" do
      weapon_type = weapon_type_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %WeaponType{} = weapon_type} =
               Combat.update_weapon_type(weapon_type, update_attrs)

      assert weapon_type.name == "some updated name"
      assert weapon_type.description == "some updated description"
    end

    test "update_weapon_type/2 with invalid data returns error changeset" do
      weapon_type = weapon_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Combat.update_weapon_type(weapon_type, @invalid_attrs)
      assert weapon_type == Combat.get_weapon_type!(weapon_type.id)
    end

    test "delete_weapon_type/1 deletes the weapon_type" do
      weapon_type = weapon_type_fixture()
      assert {:ok, %WeaponType{}} = Combat.delete_weapon_type(weapon_type)
      assert_raise Ecto.NoResultsError, fn -> Combat.get_weapon_type!(weapon_type.id) end
    end

    test "change_weapon_type/1 returns a weapon_type changeset" do
      weapon_type = weapon_type_fixture()
      assert %Ecto.Changeset{} = Combat.change_weapon_type(weapon_type)
    end
  end
end
