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

  describe "chat_actions" do
    alias Stygian.Combat.ChatAction

    import Stygian.CharactersFixtures
    import Stygian.CombatFixtures

    @invalid_attrs %{resolved: nil, accepted: nil}

    test "list_chat_actions/0 returns all chat_actions" do
      chat_action = chat_action_fixture()
      assert Combat.list_chat_actions() == [chat_action]
    end

    test "get_chat_action!/1 returns the chat_action with given id" do
      chat_action = chat_action_fixture()
      assert Combat.get_chat_action!(chat_action.id) == chat_action
    end

    test "get_chat_action/1 returns the chat_action with given id" do
      chat_action = chat_action_fixture()
      assert Combat.get_chat_action(chat_action.id) == chat_action
    end

    test "get_chat_action/1 returns nil if the chat_action does not exist" do
      assert is_nil(Combat.get_chat_action(42))
    end

    test "get_chat_action_preloaded/1" do
      chat_action = chat_action_fixture()
      chat_action = Combat.get_chat_action_preloaded(chat_action.id)

      refute is_nil(chat_action.attacker.id)
      refute is_nil(chat_action.defender.id)
      refute is_nil(chat_action.action.id)
      refute is_nil(chat_action.action.weapon_type.id)
      refute is_nil(chat_action.action.attack_attribute.id)
      refute is_nil(chat_action.action.attack_skill.id)
      refute is_nil(chat_action.action.defence_attribute.id)
      refute is_nil(chat_action.action.defence_skill.id)
    end

    test "create_chat_action/1 with valid data creates a chat_action" do
      attacker = character_fixture(%{name: "attacker"})
      defender = character_fixture(%{name: "defender"})
      action = action_fixture()

      valid_attrs = %{
        attacker_id: attacker.id,
        defender_id: defender.id,
        action_id: action.id,
        resolved: true,
        accepted: true
      }

      assert {:ok, %ChatAction{} = chat_action} = Combat.create_chat_action(valid_attrs)
      assert chat_action.resolved == true
      assert chat_action.accepted == true
    end

    test "create_chat_action/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Combat.create_chat_action(@invalid_attrs)
    end

    test "update_chat_action/2 with valid data updates the chat_action" do
      chat_action = chat_action_fixture()
      update_attrs = %{resolved: false, accepted: false}

      assert {:ok, %ChatAction{} = chat_action} =
               Combat.update_chat_action(chat_action, update_attrs)

      assert chat_action.resolved == false
      assert chat_action.accepted == false
    end

    test "update_chat_action/2 with invalid data returns error changeset" do
      chat_action = chat_action_fixture()
      assert {:error, %Ecto.Changeset{}} = Combat.update_chat_action(chat_action, @invalid_attrs)
      assert chat_action == Combat.get_chat_action!(chat_action.id)
    end

    test "delete_chat_action/1 deletes the chat_action" do
      chat_action = chat_action_fixture()
      assert {:ok, %ChatAction{}} = Combat.delete_chat_action(chat_action)
      assert_raise Ecto.NoResultsError, fn -> Combat.get_chat_action!(chat_action.id) end
    end

    test "change_chat_action/1 returns a chat_action changeset" do
      chat_action = chat_action_fixture()
      assert %Ecto.Changeset{} = Combat.change_chat_action(chat_action)
    end
  end

  describe "Create actions" do
    import Stygian.CharactersFixtures
    import Stygian.CombatFixtures
    import Stygian.MapsFixtures
    import Stygian.SkillsFixtures

    alias Stygian.Maps

    test "create_action_for_chat/2 succesfully creates an action for the defender" do
      map = map_fixture()
      attacker = character_fixture(%{name: "attacker"})
      defender = character_fixture(%{name: "defender"})

      attack_attribute = skill_fixture(%{name: "attack_attribute"})
      attack_skill = skill_fixture(%{name: "attack_skill"})
      defence_attribute = skill_fixture(%{name: "defence_attribute"})
      defence_skill = skill_fixture(%{name: "defence_skill"})

      character_skill_fixture(%{character_id: attacker.id, skill_id: attack_attribute.id})
      character_skill_fixture(%{character_id: attacker.id, skill_id: attack_skill.id})
      character_skill_fixture(%{character_id: defender.id, skill_id: defence_attribute.id})
      character_skill_fixture(%{character_id: defender.id, skill_id: defence_skill.id})

      weapon_type = weapon_type_fixture()

      combat_action =
        action_fixture(%{
          weapon_type_id: weapon_type.id,
          attack_attribute_id: attack_attribute.id,
          attack_skill_id: attack_skill.id,
          defence_attribute_id: defence_attribute.id,
          defence_skill_id: defence_skill.id
        })

      request = %{
        attacker_id: attacker.id,
        defender_id: defender.id,
        action_id: combat_action.id
      }

      assert {:ok,
              %{
                chat_action: chat_action,
                chat: chat
              }} = Combat.create_action_for_chat(request, map.id)

      assert chat_action.attacker_id == attacker.id
      assert chat_action.defender_id == defender.id
      assert chat_action.action_id == combat_action.id

      assert chat.text == "Stai ricevendo un attacco da attacker. Lo confermi?"

      assert chat.chat_action_id == chat_action.id
    end

    test "create_action_for_chat/2 does not allow creating the action if the attacker does not possess the require skill level" do
      map = map_fixture()
      attacker = character_fixture(%{name: "attacker"})
      defender = character_fixture(%{name: "defender"})

      attack_attribute = skill_fixture(%{name: "attack_attribute"})
      attack_skill = skill_fixture(%{name: "attack_skill"})
      defence_attribute = skill_fixture(%{name: "defence_attribute"})
      defence_skill = skill_fixture(%{name: "defence_skill"})

      character_skill_fixture(%{character_id: attacker.id, skill_id: attack_attribute.id})
      character_skill_fixture(%{character_id: attacker.id, skill_id: attack_skill.id, value: 1})
      character_skill_fixture(%{character_id: defender.id, skill_id: defence_attribute.id})
      character_skill_fixture(%{character_id: defender.id, skill_id: defence_skill.id})

      weapon_type = weapon_type_fixture()

      combat_action =
        action_fixture(%{
          minimum_skill_value: 2,
          weapon_type_id: weapon_type.id,
          attack_attribute_id: attack_attribute.id,
          attack_skill_id: attack_skill.id,
          defence_attribute_id: defence_attribute.id,
          defence_skill_id: defence_skill.id
        })

      request = %{
        attacker_id: attacker.id,
        defender_id: defender.id,
        action_id: combat_action.id
      }

      assert {:error,
              "Il personaggio non ha un livello sufficiente di abilità per tentare l'azione"} =
               Combat.create_action_for_chat(request, map.id)
    end

    test "cancel_chat_action/1 correctly cancel the action for the character." do
      map = map_fixture()
      attacker = character_fixture(%{name: "attacker"})
      defender = character_fixture(%{name: "defender"})

      attack_attribute = skill_fixture(%{name: "attack_attribute"})
      attack_skill = skill_fixture(%{name: "attack_skill"})
      defence_attribute = skill_fixture(%{name: "defence_attribute"})
      defence_skill = skill_fixture(%{name: "defence_skill"})

      character_skill_fixture(%{character_id: attacker.id, skill_id: attack_attribute.id})
      character_skill_fixture(%{character_id: attacker.id, skill_id: attack_skill.id})
      character_skill_fixture(%{character_id: defender.id, skill_id: defence_attribute.id})
      character_skill_fixture(%{character_id: defender.id, skill_id: defence_skill.id})

      weapon_type = weapon_type_fixture()

      combat_action =
        action_fixture(%{
          weapon_type_id: weapon_type.id,
          attack_attribute_id: attack_attribute.id,
          attack_skill_id: attack_skill.id,
          defence_attribute_id: defence_attribute.id,
          defence_skill_id: defence_skill.id
        })

      request = %{
        attacker_id: attacker.id,
        defender_id: defender.id,
        action_id: combat_action.id
      }

      assert {:ok,
              %{
                chat_action: chat_action
              }} = Combat.create_action_for_chat(request, map.id)

      assert {:ok, _} = Combat.cancel_chat_action(chat_action.id)

      assert [cancelled_chat] = Maps.list_map_chats(map.id)

      assert "L'attacco di #{attacker.name} con #{weapon_type.name}, è stato rifiutato." ==
               cancelled_chat.text

      chat_action = Combat.get_chat_action!(chat_action.id)

      assert chat_action.resolved
      refute chat_action.accepted
    end

    test "confirm_chat_action/1 correctly confirm the action for the character." do
      map = map_fixture()
      attacker = character_fixture(%{name: "attacker"})
      defender = character_fixture(%{name: "defender"})

      attack_attribute = skill_fixture(%{name: "attack_attribute"})
      attack_skill = skill_fixture(%{name: "attack_skill"})
      defence_attribute = skill_fixture(%{name: "defence_attribute"})
      defence_skill = skill_fixture(%{name: "defence_skill"})

      character_skill_fixture(%{
        character_id: attacker.id,
        skill_id: attack_attribute.id,
        value: 4
      })

      character_skill_fixture(%{character_id: attacker.id, skill_id: attack_skill.id, value: 4})

      character_skill_fixture(%{
        character_id: defender.id,
        skill_id: defence_attribute.id,
        value: 2
      })

      character_skill_fixture(%{character_id: defender.id, skill_id: defence_skill.id, value: 2})

      weapon_type = weapon_type_fixture()

      combat_action =
        action_fixture(%{
          weapon_type_id: weapon_type.id,
          attack_attribute_id: attack_attribute.id,
          attack_skill_id: attack_skill.id,
          defence_attribute_id: defence_attribute.id,
          defence_skill_id: defence_skill.id,
          minimum_skill_value: 2
        })

      request = %{
        attacker_id: attacker.id,
        defender_id: defender.id,
        action_id: combat_action.id
      }

      assert {:ok,
              %{
                chat_action: chat_action
              }} = Combat.create_action_for_chat(request, map.id)

      random_dice_thrower_mock = fn _ -> 10 end

      assert {:ok, _} = Combat.confirm_chat_action(chat_action.id, random_dice_thrower_mock)

      assert [cancelled_chat] = Maps.list_map_chats(map.id)

      assert "Attacca #{defender.name} con #{weapon_type.name}, che perde #{4} punti di salute." ==
               cancelled_chat.text

      chat_action = Combat.get_chat_action!(chat_action.id)

      assert chat_action.resolved
      assert chat_action.accepted
    end
  end
end
