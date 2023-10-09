defmodule Stygian.CharactersTest do
  use Stygian.DataCase

  alias Stygian.Characters

  describe "characters" do
    alias Stygian.Characters.Character

    import Stygian.CharactersFixtures
    import Stygian.AccountsFixtures
    import Stygian.SkillsFixtures

    @invalid_attrs %{
      admin_notes: nil,
      avatar: nil,
      biography: nil,
      cigs: nil,
      description: nil,
      experience: nil,
      health: nil,
      name: nil,
      notes: nil,
      sanity: nil,
      step: nil
    }

    test "list_characters/0 returns all characters" do
      character = character_fixture()
      assert Characters.list_characters() == [character]
    end

    test "list_characters_slim/0 returns all characters" do
      character = character_fixture(%{step: 2})
      assert [got_character] = Characters.list_characters_slim()
      assert got_character.id == character.id
      assert got_character.name == character.name
      assert nil == got_character.avatar
      assert got_character.user_id == character.user_id
    end

    test "list_npcs/0 returns only NPC characters" do
      npc = character_fixture(%{name: "Some NPC character", npc: true})
      character_fixture(%{name: "Some non NPC character"})

      assert [^npc] = Characters.list_npcs()
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Characters.get_character!(character.id) == character
    end

    test "get_character_by_name/1 returns the character when existent" do
      character = character_fixture()
      assert Characters.get_character_by_name(character.name) == character
    end

    test "get_character_by_name/1 returns nil when non existent" do
      assert Characters.get_character_by_name("some name") == nil
    end

    test "character_belongs_to_user?/2 returns true when the character belongs to the user" do
      %{id: character_id, user_id: user_id} = character_fixture()
      assert Characters.character_belongs_to_user?(character_id, user_id) == true
    end

    test "character_belongs_to_user?/2 returns false when the character does not belong to the user" do
      %{id: user_id} = user_fixture()
      %{id: character_id} = character_fixture()

      assert Characters.character_belongs_to_user?(character_id, user_id) == false
    end

    test "character_belongs_to_user?/2 returns false when the character does not exist" do
      %{id: user_id} = user_fixture()
      assert Characters.character_belongs_to_user?(40, user_id) == false
    end

    test "get_user_first_character/1 returns nil if the user has no character available created" do
      %{id: user_id} = user_fixture()
      assert Characters.get_user_first_character(%{id: user_id}) == nil
    end

    test "get_user_first_character/1 returns the only character created by the user" do
      %{id: user_id} = user_fixture()
      character = character_fixture(%{user_id: user_id})
      assert Characters.get_user_first_character(%{id: user_id}) == character
    end

    test "create_character/1 with valid data creates a character" do
      %{id: user_id} = user_fixture()

      valid_attrs = %{
        avatar: "some avatar",
        name: "some very awful name",
        age: :adult,
        sin: "Some awful sin",
        user_id: user_id
      }

      assert {:ok, %Character{} = character} = Characters.create_character(valid_attrs)
      assert character.avatar == "some avatar"
      assert character.name == "some very awful name"
      assert character.user_id == user_id
      assert character.step == 1
    end

    test "create_character/1 with valid data in a string map creates a character" do
      %{id: user_id} = user_fixture()

      valid_attrs = %{
        "avatar" => "some avatar",
        "name" => "some very awful name",
        "age" => :adult,
        "sin" => "Some awful sin",
        "user_id" => user_id
      }

      assert {:ok, %Character{} = character} = Characters.create_character(valid_attrs)
      assert character.avatar == "some avatar"
      assert character.name == "some very awful name"
      assert character.user_id == user_id
      assert character.step == 1
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Characters.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()

      update_attrs = %{
        admin_notes: "some updated admin_notes",
        avatar: "some updated avatar",
        biography: "some updated biography",
        cigs: 43,
        description: "some updated description",
        experience: 43,
        health: 43,
        name: "some updated name",
        notes: "some updated notes",
        sanity: 43,
        step: 43
      }

      assert {:ok, %Character{} = character} =
               Characters.update_character(character, update_attrs)

      assert character.admin_notes == "some updated admin_notes"
      assert character.avatar == "some updated avatar"
      assert character.biography == "some updated biography"
      assert character.cigs == 43
      assert character.description == "some updated description"
      assert character.experience == 43
      assert character.health == 43
      assert character.name == "some updated name"
      assert character.notes == "some updated notes"
      assert character.sanity == 43
      assert character.step == 43
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = Characters.update_character(character, @invalid_attrs)
      assert character == Characters.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = Characters.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> Characters.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = Characters.change_character(character)
    end

    test "rest_character/1 correctly restored lost sanity to the character" do
      character = character_fixture_complete(%{lost_sanity: 6, cigs: 10})

      assert {:ok, %Character{} = character} = Characters.rest_character(character)

      assert character.lost_sanity == 1
      assert character.cigs == 5
    end

    test "rest_character/1 correctly restored lost sanity to the character, but only the lost one" do
      character = character_fixture_complete(%{lost_sanity: 2, cigs: 10})

      assert {:ok, %Character{} = character} = Characters.rest_character(character)

      assert character.lost_sanity == 0
      assert character.cigs == 5
    end

    test "rest_character/1 does not restore sanity if sanity was already at its maximum, but subtracts the cigs" do
      character = character_fixture_complete(%{lost_sanity: 0, cigs: 10})

      assert {:ok, %Character{} = character} = Characters.rest_character(character)

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
               Characters.rest_character(character)

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
               Characters.rest_character(character)

      character = Characters.get_character!(character.id)
      assert character.lost_sanity == 6
      assert character.cigs == 4
    end
  end

  describe "character_skills" do
    alias Stygian.Characters.CharacterSkill
    alias Stygian.Skills

    import Stygian.CharactersFixtures
    import Stygian.AccountsFixtures
    import Stygian.SkillsFixtures

    @invalid_attrs %{value: nil}

    test "list_character_skills/1 returns all character_skills" do
      skill_type1 = skill_type_fixture(%{name: "Skill type 1"})
      skill_type2 = skill_type_fixture(%{name: "Skill type 2"})

      skill1 = skill_fixture(%{name: "skill1"})

      Skills.add_skill_type_to_skill(skill1, skill_type1)
      Skills.add_skill_type_to_skill(skill1, skill_type2)

      character_skill =
        %{character_id: character_id} = character_skill_fixture(%{skill_id: skill1.id})

      assert [got_character_skill] = Characters.list_character_skills(%{id: character_id})
      assert character_skill.skill_id == got_character_skill.skill_id
      assert character_skill.character_id == got_character_skill.character_id
      assert character_skill.value == got_character_skill.value
      assert Enum.member?(got_character_skill.skill.skill_types, skill_type1)
      assert Enum.member?(got_character_skill.skill.skill_types, skill_type2)
    end

    test "get_character_skill!/1 returns the character_skill with given id" do
      character_skill = character_skill_fixture()
      assert Characters.get_character_skill!(character_skill.id) == character_skill
    end

    test "get_character_skill/2 returns the character_skill when existent" do
      character_skill = character_skill_fixture()

      found =
        Characters.get_character_skill(character_skill.character_id, character_skill.skill_id)

      assert character_skill.id == found.id
      assert character_skill.character_id == found.character_id
      assert character_skill.skill_id == found.skill_id
    end

    test "get_character_skill_by_skill_name/2 returns the correct skill value for the given character" do
      skill = skill_fixture(%{name: "some skill"})

      %{character_id: character_id, value: value} =
        _ = character_skill_fixture(%{skill_id: skill.id})

      character_skill =
        Characters.get_character_skill_by_skill_name(%{id: character_id}, "some skill")

      assert value == character_skill.value
      assert character_id == character_skill.character_id
      assert skill.id == character_skill.skill_id
    end

    test "get_character_skill_by_skill_name/2 returns nil if the character does not have the skill" do
      character = character_fixture()
      assert nil == Characters.get_character_skill_by_skill_name(character, "some skill")
    end

    test "create_character_skill/1 with valid data creates a character_skill" do
      character = character_fixture()
      skill = skill_fixture()

      valid_attrs = %{
        value: 42,
        character_id: character.id,
        skill_id: skill.id
      }

      assert {:ok, %CharacterSkill{} = character_skill} =
               Characters.create_character_skill(valid_attrs)

      assert character_skill.value == 42
    end

    test "create_character_skill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Characters.create_character_skill(@invalid_attrs)
    end

    test "create_npc/2 with invalid data returns an error changeset" do
      user_fixture(%{username: "Narratore"})
      %{id: skill_id} = skill_fixture()

      invalid_character = %{
        "avatar" => "some_avatar"
      }

      skills = [
        %{skill_id: skill_id, value: 4}
      ]

      assert {:error, _} = Characters.create_npc(invalid_character, skills)
    end

    test "create_npc/2 with valid data creates the character" do
      user_fixture(%{username: "Narratore"})
      %{id: skill_id} = skill_fixture()

      valid_character = %{
        "name" => "some_name",
        "avatar" => "some_avatar",
        "sin" => "some_awful_sin",
        "age" => :adult
      }

      skills = [
        %{skill_id: skill_id, value: 4}
      ]

      assert {:ok, _} = Characters.create_npc(valid_character, skills)
      assert [npcs] = Characters.list_npcs()
      assert "some_name" == npcs.name
    end

    test "update_character_skill/1 correctly updates the character skill" do
      %{character_id: character_id, skill_id: skill_id, value: original_value} =
        character_skill_fixture()

      new_value = original_value + 1

      update_attrs = %{
        "character_id" => character_id,
        "skill_id" => skill_id,
        "new_value" => new_value
      }

      assert {:ok, %CharacterSkill{} = character_skill} =
               Characters.update_character_skill_form(update_attrs)

      assert character_skill.value == new_value
    end

    test "update_character_skill/2 with valid data updates the character_skill" do
      character_skill = character_skill_fixture()
      update_attrs = %{value: 43}

      assert {:ok, %CharacterSkill{} = character_skill} =
               Characters.update_character_skill(character_skill, update_attrs)

      assert character_skill.value == 43
    end

    test "update_character_skill/2 with invalid data returns error changeset" do
      character_skill = character_skill_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Characters.update_character_skill(character_skill, @invalid_attrs)

      assert character_skill == Characters.get_character_skill!(character_skill.id)
    end

    test "delete_character_skill/1 deletes the character_skill" do
      character_skill = character_skill_fixture()
      assert {:ok, %CharacterSkill{}} = Characters.delete_character_skill(character_skill)

      assert_raise Ecto.NoResultsError, fn ->
        Characters.get_character_skill!(character_skill.id)
      end
    end

    test "change_character_skill/1 returns a character_skill changeset" do
      character_skill = character_skill_fixture()
      assert %Ecto.Changeset{} = Characters.change_character_skill(character_skill)
    end

    test "get_user_character?/1 returns the character if user has character" do
      character = character_fixture()
      assert Characters.get_user_character?(%{id: character.user_id}) == character
    end

    test "get_user_character?/1 returns nil if user does not have character" do
      user = user_fixture()
      assert Characters.get_user_character?(user) == nil
    end

    test "assign_experience_points/2 correctly updates the character experience" do
      %{id: character_id} = character_fixture_complete(%{experience: 0})

      assert {:ok, _} =
               Characters.assign_experience_points(character_id, %{"experience" => "3"})

      assert %{experience: 3} = Characters.get_character!(character_id)
    end

    test "assign_experience_points/2 correctly reduces the character experience" do
      %{id: character_id} = character_fixture_complete(%{experience: 3})

      assert {:ok, _} =
               Characters.assign_experience_points(character_id, %{"experience" => "-2"})

      assert %{experience: 1} = Characters.get_character!(character_id)
    end

    test "assign_experience_points/2 does not reduce the character experience when under 0" do
      %{id: character_id} = character_fixture_complete(%{experience: 1})

      assert {:error, changeset} =
               Characters.assign_experience_points(character_id, %{"experience" => "-2"})

      assert %{
               errors: [
                 experience: {"Non è possibile ridurre l'esperienza ad un valore minore di 0.", _}
               ]
             } = changeset
    end

    test "assign_character_status/2 correctly assign the right health and sanity loss to the character" do
      %{id: character_id} =
        character_fixture_complete(%{health: 100, sanity: 50, lost_health: 0, lost_sanity: 0})

      assert {:ok, _} =
               Characters.assign_character_status(character_id, %{"health" => 70, "sanity" => 40})

      assert %{health: 100, sanity: 50, lost_health: 30, lost_sanity: 10} =
               Characters.get_character!(character_id)
    end

    test "assign_character_status/2 does not assign the health when the specified value is greater than the character's health" do
      %{id: character_id} =
        character_fixture_complete(%{health: 100, sanity: 50, lost_health: 0, lost_sanity: 0})

      assert {:error, changeset} =
               Characters.assign_character_status(character_id, %{"health" => 110, "sanity" => 40})

      assert %{
               errors: [
                 health: {"Il valore specificato è maggiore della salute del personaggio.", _}
               ]
             } = changeset
    end

    test "assign_character_status/2 does not assign the sanity when the specified value is greater than the character's sanity" do
      %{id: character_id} =
        character_fixture_complete(%{health: 100, sanity: 50, lost_health: 0, lost_sanity: 0})

      assert {:error, changeset} =
               Characters.assign_character_status(character_id, %{"health" => 90, "sanity" => 60})

      assert %{
               errors: [
                 sanity: {"Il valore specificato è maggiore della sanità del personaggio.", _}
               ]
             } = changeset
    end
  end

  describe "character_effects" do
    alias Stygian.Characters.CharacterEffect

    import Stygian.CharacterEffectsFixtures
    import Stygian.CharactersFixtures
    import Stygian.ObjectsFixtures

    @invalid_attrs %{}

    test "list_character_effects/0 returns all character_effects" do
      character_effect = character_effect_fixture()
      assert Characters.list_character_effects() == [character_effect]
    end

    test "list_active_character_effects/1 lists all the active effects for the character" do
      %{id: character_id} = character_fixture()
      %{id: object_id_1} = object_fixture(%{name: "object 1"})
      %{id: object_id_2} = object_fixture(%{name: "object 2"})

      before_limit =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(-1 * 4, :hour)

      character_effect_fixture(%{
        character_id: character_id,
        object_id: object_id_1,
        inserted_at: before_limit
      })

      character_effect_fixture(%{character_id: character_id, object_id: object_id_2})

      assert [got_character_effect] = Characters.list_active_character_effects(character_id)

      assert got_character_effect.object_id == object_id_2
    end

    test "list_active_character_effects/1 returns an empty list when no active effect exists for the character" do
      %{id: character_id} = character_fixture()
      assert [] = Characters.list_active_character_effects(character_id)
    end

    test "character_has_effect?/2 returns true when the character has the effects given by the object" do
      %{id: character_id} = character_fixture()
      %{id: object_id} = object_fixture(%{name: "object"})

      character_effect_fixture(%{character_id: character_id, object_id: object_id})

      assert Characters.character_has_effect?(character_id, object_id)
    end

    test "character_has_effect?/2 returns false when the character has no effects given by the object" do
      %{id: character_id} = character_fixture()
      %{id: object_id} = object_fixture(%{name: "object"})

      refute Characters.character_has_effect?(character_id, object_id)
    end

    test "get_character_effect!/1 returns the character_effect with given id" do
      character_effect = character_effect_fixture()
      assert Characters.get_character_effect!(character_effect.id) == character_effect
    end

    test "create_character_effect/1 with valid data creates a character_effect" do
      %{id: character_id} = character_fixture()
      %{id: object_id} = object_fixture()

      valid_attrs = %{
        character_id: character_id,
        object_id: object_id
      }

      assert {:ok, %CharacterEffect{} = _} = Characters.create_character_effect(valid_attrs)
    end

    test "create_character_effect/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Characters.create_character_effect(@invalid_attrs)
    end

    test "update_character_effect/2 with valid data updates the character_effect" do
      character_effect = character_effect_fixture()
      update_attrs = %{}

      assert {:ok, %CharacterEffect{} = _} =
               Characters.update_character_effect(character_effect, update_attrs)
    end

    test "delete_character_effect/1 deletes the character_effect" do
      character_effect = character_effect_fixture()
      assert {:ok, %CharacterEffect{}} = Characters.delete_character_effect(character_effect)

      assert_raise Ecto.NoResultsError, fn ->
        Characters.get_character_effect!(character_effect.id)
      end
    end

    test "change_character_effect/1 returns a character_effect changeset" do
      character_effect = character_effect_fixture()
      assert %Ecto.Changeset{} = Characters.change_character_effect(character_effect)
    end

    test "use_object/1 correctly creates an effect for the character" do
      %{id: character_object_id, character_id: character_id, object_id: object_id} = character_object_fixture()

      assert {:ok, _} = Characters.use_object(character_object_id)

      assert Characters.character_has_effect?(character_id, object_id)
    end

    test "use_object/1 returns an error when the character does not own the object" do
      assert {:error, "Il personaggio non possiede l'oggetto selezionato."} = Characters.use_object(42)
    end

    test "use_object/1 returns an error when the character tries to use the same object" do
      %{id: character_id} = character_fixture()
      %{id: object_id} = object_fixture()

      %{id: character_object_id_1} = character_object_fixture(%{
        character_id: character_id,
        object_id: object_id
      })

      %{id: character_object_id_2} = character_object_fixture(%{
        character_id: character_id,
        object_id: object_id
      })

      assert {:ok, _} = Characters.use_object(character_object_id_1)
      assert {:error, _} = Characters.use_object(character_object_id_2)
    end
  end
end
