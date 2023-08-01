defmodule Stygian.CharactersTest do
  use Stygian.DataCase

  alias Stygian.Characters

  describe "characters" do
    alias Stygian.Characters.Character

    import Stygian.CharactersFixtures
    import Stygian.AccountsFixtures

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
        admin_notes: "some admin_notes",
        avatar: "some avatar",
        biography: "some biography",
        cigs: 42,
        description: "some description",
        experience: 42,
        health: 42,
        name: "some name",
        notes: "some notes",
        sanity: 42,
        step: 42,
        user_id: user_id
      }

      assert {:ok, %Character{} = character} = Characters.create_character(valid_attrs)
      assert character.admin_notes == "some admin_notes"
      assert character.avatar == "some avatar"
      assert character.biography == "some biography"
      assert character.cigs == 42
      assert character.description == "some description"
      assert character.experience == 42
      assert character.health == 42
      assert character.name == "some name"
      assert character.notes == "some notes"
      assert character.sanity == 42
      assert character.step == 42
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
      character_skill = character_skill_fixture()
      assert Characters.list_character_skills() == [character_skill]
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

    test "user_has_character?/1 returns true if user has character" do
      character = character_fixture()
      assert Characters.user_has_character?(%{id: character.user_id})
    end

    test "user_has_character?/1 returns false if user does not have character" do
      user = user_fixture()
      assert !Characters.user_has_character?(user)
    end
  end
end
