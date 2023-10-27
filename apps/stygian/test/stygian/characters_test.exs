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

    test "get_character_slim/1 gets only the required character inforamtion" do
      character = character_fixture_complete()
      found = Characters.get_character_slim(character.id)

      assert found.id == character.id
      assert found.name == character.name
      assert found.avatar == character.avatar
      assert found.description == character.description
      assert found.health == character.health
      assert found.sanity == character.sanity
      assert found.lost_health == character.lost_health
      assert found.lost_sanity == character.lost_sanity

      assert is_nil(found.biography)
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
  end

  describe "character_skills" do
    alias Stygian.Characters.CharacterSkill
    alias Stygian.Skills

    import Stygian.AccountsFixtures
    import Stygian.CharactersFixtures
    import Stygian.ObjectsFixtures
    import Stygian.SkillsFixtures

    @invalid_attrs %{value: nil}

    test "list_character_skills/1 returns all character_skills" do
      skill_type_1 = skill_type_fixture(%{name: "Skill type 1"})
      skill_type_2 = skill_type_fixture(%{name: "Skill type 2"})

      skill_1 = skill_fixture(%{name: "skill_1"})

      Skills.add_skill_type_to_skill(skill_1, skill_type_1)
      Skills.add_skill_type_to_skill(skill_1, skill_type_2)

      character_skill =
        %{character_id: character_id} = character_skill_fixture(%{skill_id: skill_1.id})

      assert [got_character_skill] = Characters.list_character_skills(%{id: character_id})
      assert character_skill.skill_id == got_character_skill.skill_id
      assert character_skill.character_id == got_character_skill.character_id
      assert character_skill.value == got_character_skill.value
      assert Enum.member?(got_character_skill.skill.skill_types, skill_type_1)
      assert Enum.member?(got_character_skill.skill.skill_types, skill_type_2)
    end

    test "list_character_attributes_skills/1 returns attributes and characters on two different lists" do
      skill_type_1 = skill_type_fixture(%{name: "Attribute"})
      skill_type_2 = skill_type_fixture(%{name: "Skill"})

      skill_1 = skill_fixture(%{name: "skill1"})
      skill_2 = skill_fixture(%{name: "skill2"})

      Skills.add_skill_type_to_skill(skill_1, skill_type_1)
      Skills.add_skill_type_to_skill(skill_2, skill_type_2)

      character_skill_1 =
        %{character_id: character_id} = character_skill_fixture(%{skill_id: skill_1.id})

      character_skill_2 =
        character_skill_fixture(%{character_id: character_id, skill_id: skill_2.id})

      assert {attributes, skills} =
               Characters.list_character_attributes_skills(%{id: character_id})

      assert 1 == length(attributes)
      assert 1 == length(skills)

      {character_skill_id_1, character_skill_id_2} = {character_skill_1.id, character_skill_2.id}

      assert [%{id: ^character_skill_id_1}] = attributes
      assert [%{id: ^character_skill_id_2}] = skills
    end

    test "list_character_attributes_skills/1 returns two empty lists when character is nil" do
      assert {[], []} = Characters.list_character_attributes_skills(nil)
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

    test "get_character_skill_effect_value/2 returns the skill value for the character with the right object effects" do
      %{id: character_id} = character_fixture()
      %{id: skill_id} = skill_fixture(%{name: "some skill"})
      %{id: object_id} = object_fixture(%{name: "some object"})

      %{id: character_object_id} =
        character_object_fixture(%{character_id: character_id, object_id: object_id})

      character_skill_fixture(%{character_id: character_id, skill_id: skill_id, value: 4})
      effect_fixture(%{object_id: object_id, skill_id: skill_id, value: 2})
      effect_fixture(%{object_id: object_id, skill_id: skill_id, value: -1})
      Characters.use_object(character_object_id)

      assert 5 == Characters.get_character_skill_effect_value(character_id, skill_id)
    end

    test "get_character_skill_effect_value/2 returns the skill value for the character without fatigue effects" do
      %{id: character_id} = character_fixture(%{fatigue: 70})
      %{id: skill_id} = skill_fixture(%{name: "some skill"})
      character_skill_fixture(%{character_id: character_id, skill_id: skill_id, value: 4})

      assert 4 == Characters.get_character_skill_effect_value(character_id, skill_id)
    end

    test "get_character_skill_effect_value/2 returns the skill value for the character with minimum fatigue effects" do
      %{id: character_id} = character_fixture(%{fatigue: 80})
      skill_type = skill_type_fixture(%{name: "Attribute"})
      %{id: skill_id} = skill = skill_fixture(%{name: "some skill"})
      Skills.add_skill_type_to_skill(skill, skill_type)

      character_skill_fixture(%{character_id: character_id, skill_id: skill_id, value: 4})

      assert 3 == Characters.get_character_skill_effect_value(character_id, skill_id)
    end

    test "get_character_skill_effect_value/2 returns the skill value for the character with right fatigue effects" do
      %{id: character_id} = character_fixture(%{fatigue: 100})
      skill_type = skill_type_fixture(%{name: "Attribute"})
      %{id: skill_id} = skill = skill_fixture(%{name: "some skill"})
      Skills.add_skill_type_to_skill(skill, skill_type)

      character_skill_fixture(%{character_id: character_id, skill_id: skill_id, value: 3})

      assert 2 == Characters.get_character_skill_effect_value(character_id, skill_id)
    end

    test "get_character_skill_effect_value/2 returns the minimum skill value for the character with right fatigue effects" do
      %{id: character_id} = character_fixture(%{fatigue: 90})
      skill_type = skill_type_fixture(%{name: "Attribute"})
      %{id: skill_id} = skill = skill_fixture(%{name: "some skill"})
      Skills.add_skill_type_to_skill(skill, skill_type)

      character_skill_fixture(%{character_id: character_id, skill_id: skill_id, value: 4})

      assert 2 == Characters.get_character_skill_effect_value(character_id, skill_id)
    end

    test "get_character_skill_effect_value/2 returns the skill value if it is not an attribute" do
      %{id: character_id} = character_fixture(%{fatigue: 90})
      skill_type = skill_type_fixture(%{name: "Skill"})
      %{id: skill_id} = skill = skill_fixture(%{name: "some skill"})
      Skills.add_skill_type_to_skill(skill, skill_type)

      character_skill_fixture(%{character_id: character_id, skill_id: skill_id, value: 3})

      assert 3 == Characters.get_character_skill_effect_value(character_id, skill_id)
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
      assert [npc] = Characters.list_npcs()
      assert "some_name" == npc.name
      refute is_nil(npc.health)
      refute is_nil(npc.sanity)
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

    test "assign_research_points/2 correctly assign experience points to the character" do
      %{id: character_id} = character_fixture_complete(%{research_points: 0})

      assert {:ok, _} =
               Characters.assign_research_points(character_id, %{"research_points" => "3"})

      character = Characters.get_character!(character_id)

      assert 3 == character.research_points
    end

    test "assign_character_status/2 correctly assign the right health and sanity loss to the character, along with its fatigue" do
      %{id: character_id} =
        character_fixture_complete(%{
          health: 100,
          sanity: 50,
          lost_health: 0,
          lost_sanity: 0,
          fatigue: 10
        })

      assert {:ok, _} =
               Characters.assign_character_status(character_id, %{
                 "health" => 70,
                 "sanity" => 40,
                 "fatigue" => 20
               })

      assert %{health: 100, sanity: 50, lost_health: 30, lost_sanity: 10, fatigue: 20} =
               Characters.get_character!(character_id)
    end

    test "assign_character_status/2 does not assign the health when the specified value is greater than the character's health" do
      %{id: character_id} =
        character_fixture_complete(%{
          health: 100,
          sanity: 50,
          lost_health: 0,
          lost_sanity: 0,
          fatigue: 10
        })

      assert {:error, changeset} =
               Characters.assign_character_status(character_id, %{
                 "health" => 110,
                 "sanity" => 40,
                 "fatigue" => 20
               })

      assert %{
               errors: [
                 health: {"Il valore specificato è maggiore della salute del personaggio.", _}
               ]
             } = changeset

      character = Characters.get_character!(character_id)

      assert 0 == character.lost_health
      assert 0 == character.lost_sanity
      assert 10 == character.fatigue
    end

    test "assign_character_status/2 does not assign the sanity when the specified value is greater than the character's sanity" do
      %{id: character_id} =
        character_fixture_complete(%{
          health: 100,
          sanity: 50,
          lost_health: 0,
          lost_sanity: 0,
          fatigue: 10
        })

      assert {:error, changeset} =
               Characters.assign_character_status(character_id, %{
                 "health" => 90,
                 "sanity" => 60,
                 "fatigue" => 20
               })

      assert %{
               errors: [
                 sanity: {"Il valore specificato è maggiore della sanità del personaggio.", _}
               ]
             } = changeset

      character = Characters.get_character!(character_id)

      assert 0 == character.lost_health
      assert 0 == character.lost_sanity
      assert 10 == character.fatigue
    end

    test "assign_character_status/2 assign fatigue to 100 when a greater number is assigned" do
      %{id: character_id} =
        character_fixture_complete(%{
          health: 100,
          sanity: 50,
          lost_health: 0,
          lost_sanity: 0,
          fatigue: 10
        })

      assert {:ok, _} =
               Characters.assign_character_status(character_id, %{
                 "health" => 90,
                 "sanity" => 20,
                 "fatigue" => 120
               })

      character = Characters.get_character!(character_id)

      assert 10 == character.lost_health
      assert 30 == character.lost_sanity
      assert 100 == character.fatigue
    end
  end

  describe "character_effects" do
    alias Stygian.Characters.CharacterEffect
    alias Stygian.Objects

    import Stygian.CharacterEffectsFixtures
    import Stygian.CharactersFixtures
    import Stygian.ObjectsFixtures
    import Stygian.SkillsFixtures

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

    test "list_active_character_effects/0 returns the list of active effects" do
      %{id: character_id} = character_fixture()
      %{id: object_id_1} = object_fixture(%{name: "object 1"})
      %{id: object_id_2} = object_fixture(%{name: "object 2"})

      %{id: skill_id} = skill_fixture(%{name: "skill 1"})
      effect_fixture(%{object_id: object_id_1, skill_id: skill_id})
      %{id: effect_id} = effect_fixture(%{object_id: object_id_2, skill_id: skill_id})

      before_limit =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(-1 * 4, :hour)

      character_effect_fixture(%{
        character_id: character_id,
        object_id: object_id_1,
        inserted_at: before_limit
      })

      character_effect_fixture(%{character_id: character_id, object_id: object_id_2})

      assert [%{character: character, effect: effect}] =
               Characters.list_active_character_effects()

      assert character.id == character_id
      assert effect.id == effect_id
    end

    test "list_active_character_effects/0 returns an empty list when no active effects are present" do
      %{id: character_id} = character_fixture()
      %{id: object_id_1} = object_fixture(%{name: "object 1"})
      %{id: skill_id} = skill_fixture(%{name: "skill 1"})
      effect_fixture(%{object_id: object_id_1, skill_id: skill_id})

      before_limit =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(-1 * 4, :hour)

      character_effect_fixture(%{
        character_id: character_id,
        object_id: object_id_1,
        inserted_at: before_limit
      })

      assert [] = Characters.list_active_character_effects()
    end

    test "list_active_character_skill_effects/1 lists all the active skill effects for the character" do
      %{id: character_id} = character_fixture()
      %{id: object_id_1} = object_fixture(%{name: "object 1"})
      %{id: object_id_2} = object_fixture(%{name: "object 2"})

      %{id: _} = effect_fixture(%{name: "effect 1", object_id: object_id_1})
      %{id: effect_id_2} = effect_fixture(%{name: "effect 2", object_id: object_id_2})

      before_limit =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(-1 * 4, :hour)

      character_effect_fixture(%{
        character_id: character_id,
        object_id: object_id_1,
        inserted_at: before_limit
      })

      character_effect_fixture(%{character_id: character_id, object_id: object_id_2})

      assert [got_effect] = Characters.list_active_character_skill_effects(character_id)

      assert got_effect.id == effect_id_2
    end

    test "character_has_effect?/2 returns true when the character has the effects given by the object" do
      %{id: character_id} = character_fixture()
      %{id: object_id} = object_fixture(%{name: "object"})

      character_effect_fixture(%{character_id: character_id, object_id: object_id})

      assert Characters.character_has_effect?(character_id, object_id)
    end

    test "character_has_effect?/2 returns false when the character has the effects given by the object, but it's expired" do
      %{id: character_id} = character_fixture()
      %{id: object_id} = object_fixture(%{name: "object"})

      before_limit =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(-1 * 4, :hour)

      character_effect_fixture(%{
        character_id: character_id,
        object_id: object_id,
        inserted_at: before_limit
      })

      refute Characters.character_has_effect?(character_id, object_id)
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
      %{id: character_object_id, character_id: character_id, object_id: object_id, usages: usages} =
        character_object_fixture()

      assert {:ok, _} = Characters.use_object(character_object_id)

      assert Characters.character_has_effect?(character_id, object_id)

      character_object = Objects.get_character_object!(character_object_id)

      assert character_object.usages == usages - 1
    end

    test "use_object/1 returns an error when the character does not own the object" do
      assert {:error, "Il personaggio non possiede l'oggetto selezionato."} =
               Characters.use_object(42)
    end

    test "use_object/1 returns an error when the character tries to use the same object" do
      %{id: character_id} = character_fixture()
      %{id: object_id} = object_fixture()

      %{id: character_object_id, usages: usages} =
        character_object_fixture(%{
          character_id: character_id,
          object_id: object_id
        })

      assert {:ok, _} = Characters.use_object(character_object_id)

      assert {:error, "Il personaggio ha già l'effetto dell'oggetto selezionato."} =
               Characters.use_object(character_object_id)

      character_object = Objects.get_character_object!(character_object_id)

      assert character_object.usages == usages - 1
    end

    test "use_object/1 returns an error when the character tries to use the another object of the same type" do
      %{id: character_id} = character_fixture()
      %{id: object_id} = object_fixture()

      %{id: character_object_id_1, usages: usages_1} =
        character_object_fixture(%{
          character_id: character_id,
          object_id: object_id
        })

      %{id: character_object_id_2, usages: usages_2} =
        character_object_fixture(%{
          character_id: character_id,
          object_id: object_id
        })

      assert {:ok, _} = Characters.use_object(character_object_id_1)

      assert {:error, "Il personaggio ha già l'effetto dell'oggetto selezionato."} =
               Characters.use_object(character_object_id_2)

      character_object_1 = Objects.get_character_object!(character_object_id_1)
      character_object_2 = Objects.get_character_object!(character_object_id_2)

      assert character_object_1.usages == usages_1 - 1
      assert character_object_2.usages == usages_2
    end

    test "use_object/1 does not allow object usage when the usages are 0" do
      %{id: character_object_id} =
        character_object_fixture(%{
          usages: 0
        })

      assert {:error, "L'oggetto non ha più utilizzi disponibili."} =
               Characters.use_object(character_object_id)
    end

    test "use_object/1 correctly updates the health and sanity of the character" do
      %{id: object_id} = object_fixture(%{health: -5, sanity: 10})

      %{id: character_id} =
        character_fixture_complete(%{health: 100, sanity: 50, lost_health: 10, lost_sanity: 20})

      %{id: character_object_id} =
        character_object_fixture(%{character_id: character_id, object_id: object_id})

      assert {:ok, _} = Characters.use_object(character_object_id)

      character = Characters.get_character!(character_id)

      assert 15 == character.lost_health
      assert 10 == character.lost_sanity
    end

    test "use_object/1 does not update the health of the character when it would remove all of it" do
      %{id: object_id} = object_fixture(%{health: -15, sanity: 10})

      %{id: character_id} =
        character_fixture_complete(%{health: 100, sanity: 50, lost_health: 90, lost_sanity: 20})

      %{id: character_object_id} =
        character_object_fixture(%{character_id: character_id, object_id: object_id})

      assert {:error, "Il personaggio non può perdere più salute."} =
               Characters.use_object(character_object_id)
    end

    test "use_object/1 does not update the sanity of the character when it would remove all of it" do
      %{id: object_id} = object_fixture(%{health: -15, sanity: -10})

      %{id: character_id} =
        character_fixture_complete(%{health: 100, sanity: 50, lost_health: 10, lost_sanity: 45})

      %{id: character_object_id} =
        character_object_fixture(%{character_id: character_id, object_id: object_id})

      assert {:error, "Il personaggio non può perdere più sanità mentale."} =
               Characters.use_object(character_object_id)
    end

    test "use_object/1 correctly updates the health and sanity of the character to the maximum" do
      %{id: object_id} = object_fixture(%{health: 20, sanity: 20})

      %{id: character_id} =
        character_fixture_complete(%{health: 100, sanity: 50, lost_health: 10, lost_sanity: 10})

      %{id: character_object_id} =
        character_object_fixture(%{character_id: character_id, object_id: object_id})

      assert {:ok, _} = Characters.use_object(character_object_id)

      character = Characters.get_character!(character_id)

      assert 0 == character.lost_health
      assert 0 == character.lost_sanity
    end

    test "smoke_cig/1 updates the character smoking a cig" do
      %{id: character_id} = character_fixture_complete(%{cigs: 10, sanity: 40, lost_sanity: 10})

      assert {:ok, _} = Characters.smoke_cig(character_id)

      character = Characters.get_character!(character_id)

      assert 9 == character.cigs
      assert 7 == character.lost_sanity
    end

    test "smoke_cig/1 updates the character smoking a cig but not the status when last update in less than 3 hours" do
      %{id: character_id} = character_fixture_complete(%{cigs: 10, sanity: 40, lost_sanity: 10})

      assert {:ok, _} = Characters.smoke_cig(character_id)
      assert {:ok, _} = Characters.smoke_cig(character_id)

      character = Characters.get_character!(character_id)

      assert 8 == character.cigs
      assert 7 == character.lost_sanity
    end

    test "smoke_cig/1 does not allow change the character status if the character does not have cigs" do
      %{id: character_id} = character_fixture_complete(%{cigs: 0, sanity: 40, lost_sanity: 10})

      assert {:error, _} = Characters.smoke_cig(character_id)

      character = Characters.get_character!(character_id)

      assert 0 == character.cigs
      assert 10 == character.lost_sanity
    end

    test "smoke_cig/1 does not update the character sanity below 0" do
      %{id: character_id} = character_fixture_complete(%{cigs: 10, sanity: 40, lost_sanity: 3})

      assert {:ok, _} = Characters.smoke_cig(character_id)

      character = Characters.get_character!(character_id)

      assert 9 == character.cigs
      assert 0 == character.lost_sanity
    end
  end
end
