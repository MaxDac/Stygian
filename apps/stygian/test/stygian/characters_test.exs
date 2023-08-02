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

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Characters.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      %{id: user_id} = user_fixture()

      valid_attrs = %{
        avatar: "some avatar",
        name: "some very awful name",
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
        "user_id" => user_id
      }

      assert {:ok, %Character{} = character} = Characters.create_character(valid_attrs)
      assert character.avatar == "some avatar"
      assert character.name == "some very awful name"
      assert character.user_id == user_id
      assert character.step == 1
    end

    test "complete_character/2 completes the character with the correct set of skills" do
      %{id: user_id} = user_fixture()

      valid_attrs = %{
        avatar: "some avatar",
        name: "some very awful name",
        user_id: user_id
      }

      assert {:ok, %Character{} = character} = Characters.create_character(valid_attrs)

      skills = [
        %{id: skill_id_1} = skill_fixture(%{name: "some skill 1"}),
        %{id: skill_id_2} = skill_fixture(%{name: "some skill 2"}),
        %{id: skill_id_3} = skill_fixture(%{name: "some skill 3"}),
        %{id: skill_id_4} = skill_fixture(%{name: "some skill 4"})
      ]

      skills = [
        %{value: 4, character_id: character.id, skill_id: skill_id_1},
        %{value: 3, character_id: character.id, skill_id: skill_id_2},
        %{value: 2, character_id: character.id, skill_id: skill_id_3},
        %{value: 1, character_id: character.id, skill_id: skill_id_4}
      ]

      assert {:ok, character} = Characters.complete_character(character, skills)
      assert 2 == character.step

      character_skills = Characters.list_character_skills(character)

      assert length(character_skills) == 4
      assert Enum.at(character_skills, 0).skill.name == "some skill 1"
      assert Enum.at(character_skills, 0).value == 4
      assert Enum.at(character_skills, 1).skill.name == "some skill 2"
      assert Enum.at(character_skills, 1).value == 3
      assert Enum.at(character_skills, 2).skill.name == "some skill 3"
      assert Enum.at(character_skills, 2).value == 2
      assert Enum.at(character_skills, 3).skill.name == "some skill 4"
      assert Enum.at(character_skills, 3).value == 1
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

    import Stygian.CharactersFixtures
    import Stygian.AccountsFixtures
    import Stygian.SkillsFixtures

    @invalid_attrs %{value: nil}

    test "list_character_skills/0 returns all character_skills" do
      character_skill = %{character_id: character_id} = character_skill_fixture()
      assert [got_character_skill] = Characters.list_character_skills(%{id: character_id})
      assert character_skill.skill_id == got_character_skill.skill_id
      assert character_skill.character_id == got_character_skill.character_id
      assert character_skill.value == got_character_skill.value
    end

    test "get_character_skill!/1 returns the character_skill with given id" do
      character_skill = character_skill_fixture()
      assert Characters.get_character_skill!(character_skill.id) == character_skill
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
  end
end
