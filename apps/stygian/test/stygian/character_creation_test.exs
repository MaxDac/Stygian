defmodule Stygian.CharacterCreationTest do
  use Stygian.DataCase

  alias Stygian.Characters

  describe "character creation" do
    import Stygian.CharactersFixtures
    import Stygian.SkillsFixtures

    setup do
      %{
        character: character_fixture()
      }
    end

    test "create_character_skills/2 returns an error if the wrong number of attributes are passed in input",
         %{character: %{id: character_id}} do
      create_character_skill = fn attrs = %{value: value} ->
        skill = skill_fixture(attrs |> Map.delete(:value))

        %{
          character_id: character_id,
          skill_id: skill.id,
          value: value
        }
      end

      attributes =
        1..5
        |> Enum.map(fn i ->
          %{
            character_id: character_id,
            name: "skill_#{i}",
            value:
              if i == 6 do
                8
              else
                5
              end
          }
        end)
        |> Enum.map(&create_character_skill.(&1))

      abilities =
        1..5
        |> Enum.map(fn i -> %{name: "ability_#{i}", value: 1} end)
        |> Enum.map(&create_character_skill.(&1))

      assert {:error, changeset} = Characters.create_character_skills(attributes, abilities)
      assert %{errors: [character_attributes: {"wrong number of attributes", _}]} = changeset
      assert %{step: 1} = Characters.get_character!(character_id)
    end

    test "create_character_skills/2 returns an error if the wrong number of abilities are passed in input",
         %{character: %{id: character_id}} do
      create_character_skill = fn attrs = %{value: value} ->
        skill = skill_fixture(attrs |> Map.delete(:value))

        %{
          character_id: character_id,
          skill_id: skill.id,
          value: value
        }
      end

      attributes =
        1..6
        |> Enum.map(fn i ->
          %{
            character_id: character_id,
            name: "skill_#{i}",
            value:
              if i == 6 do
                8
              else
                5
              end
          }
        end)
        |> Enum.map(&create_character_skill.(&1))

      abilities =
        1..5
        |> Enum.map(fn i -> %{name: "ability_#{i}", value: 2} end)
        |> Enum.map(&create_character_skill.(&1))

      assert {:error, changeset} = Characters.create_character_skills(attributes, abilities)
      assert %{errors: [character_attributes: {"wrong number of attributes", _}]} = changeset
      assert %{step: 1} = Characters.get_character!(character_id)
    end

    test "create_character_skills/2 returns an error if the attribute values sum is less than expected",
         %{character: %{id: character_id}} do
      create_character_skill = fn attrs = %{value: value} ->
        skill = skill_fixture(attrs |> Map.delete(:value))

        %{
          character_id: character_id,
          skill_id: skill.id,
          value: value
        }
      end

      attributes =
        1..6
        |> Enum.map(fn i ->
          %{
            character_id: character_id,
            name: "skill_#{i}",
            value: 5
          }
        end)
        |> Enum.map(&create_character_skill.(&1))

      abilities =
        1..5
        |> Enum.map(fn i -> %{name: "ability_#{i}", value: 2} end)
        |> Enum.map(&create_character_skill.(&1))

      assert {:error, changeset} = Characters.create_character_skills(attributes, abilities)
      assert %{errors: [character_attributes: {"wrong number of attributes", _}]} = changeset
      assert %{step: 1} = Characters.get_character!(character_id)
    end

    test "create_character_skills/2 returns an error if the attribute values sum is more than expected",
         %{character: %{id: character_id}} do
      create_character_skill = fn attrs = %{value: value} ->
        skill = skill_fixture(attrs |> Map.delete(:value))

        %{
          character_id: character_id,
          skill_id: skill.id,
          value: value
        }
      end

      attributes =
        1..6
        |> Enum.map(fn i ->
          %{
            character_id: character_id,
            name: "skill_#{i}",
            value: 7
          }
        end)
        |> Enum.map(&create_character_skill.(&1))

      abilities =
        1..5
        |> Enum.map(fn i -> %{name: "ability_#{i}", value: 2} end)
        |> Enum.map(&create_character_skill.(&1))

      assert {:error, changeset} = Characters.create_character_skills(attributes, abilities)
      assert %{errors: [character_attributes: {"wrong number of attributes", _}]} = changeset
      assert %{step: 1} = Characters.get_character!(character_id)
    end

    test "create_character_skills/2 returns ok when all the parameters pass the checks", %{
      character: %{id: character_id}
    } do
      create_character_skill = fn attrs = %{value: value} ->
        skill = skill_fixture(attrs |> Map.delete(:value))

        %{
          character_id: character_id,
          skill_id: skill.id,
          value: value
        }
      end

      attributes =
        1..6
        |> Enum.map(fn i ->
          %{
            character_id: character_id,
            name: "skill_#{i}",
            value:
              if i == 6 do
                8
              else
                5
              end
          }
        end)
        |> Enum.map(&create_character_skill.(&1))

      abilities =
        1..5
        |> Enum.map(fn i -> %{name: "ability_#{i}", value: 1} end)
        |> Enum.map(&create_character_skill.(&1))

      assert {:ok, _} = Characters.create_character_skills(attributes, abilities)
      character_skills = Characters.list_character_skills(%{id: character_id})

      assert 11 == Enum.count(character_skills)
      assert 33 + 5 == Enum.sum(Enum.map(character_skills, & &1.value))
      assert %{step: 1} = Characters.get_character!(character_id)
    end

    test "complete_character/1 completes the character", %{character: character} do
      assert {:ok, %{step: 2}} = Characters.complete_character(character)
    end

    test "complete_character/1 leaves the character untouched if completed again" do
      character = character_fixture(%{name: "some other name", step: 2})
      assert {:ok, %{step: 2}} = Characters.complete_character(character)
    end

    test "complete_character/1 automatically puts the correct status for the character", %{
      character: character
    } do
      %{id: physique_id} = skill_fixture(%{name: "Fisico"})
      %{id: mind_id} = skill_fixture(%{name: "Mente"})
      %{id: will_id} = skill_fixture(%{name: "Volontà"})

      character_skill_fixture(%{character_id: character.id, skill_id: physique_id, value: 3})
      character_skill_fixture(%{character_id: character.id, skill_id: mind_id, value: 4})
      character_skill_fixture(%{character_id: character.id, skill_id: will_id, value: 5})

      assert {:ok, character} = Characters.complete_character(character)

      assert 2 == character.step
      assert 200 == character.cigs
      assert 0 == character.experience
      assert 32 == character.health
      assert 45 == character.sanity
    end
  end
end
