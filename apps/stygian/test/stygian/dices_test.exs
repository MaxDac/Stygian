defmodule Stygian.DicesTest do
  use Stygian.DataCase

  alias Stygian.Characters
  alias Stygian.Dices

  describe "Dice throw chat creation" do
    alias Stygian.Skills

    import Stygian.MapsFixtures
    import Stygian.SkillsFixtures
    import Stygian.CharactersFixtures

    setup do
      map = map_fixture()
      character = character_fixture_complete()

      skill1 = skill_fixture(%{name: "skill1"})
      skill2 = skill_fixture(%{name: "skill2"})

      character_skill_1 =
        character_skill_fixture(%{character_id: character.id, skill_id: skill1.id, value: 5})
        |> Repo.preload(:skill)

      character_skill_2 =
        character_skill_fixture(%{character_id: character.id, skill_id: skill2.id, value: 2})
        |> Repo.preload(:skill)

      %{
        map: map,
        character: character,
        skill1: skill1,
        skill2: skill2,
        character_skill_1: character_skill_1,
        character_skill_2: character_skill_2
      }
    end

    test "create_dice_throw_chat_entry/2 Returns a critical failure", %{
      map: map,
      character: character,
      skill1: skill1,
      skill2: skill2,
      character_skill_1: character_skill_1,
      character_skill_2: character_skill_2
    } do
      assert {:ok, chat} =
               Dices.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 3,
                   difficulty: 18
                 },
                 fn _ -> 1 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} + 3 con Diff. 18 ottenendo un fallimento critico (10 + 1)."
    end

    test "create_dice_throw_chat_entry/2 Returns a critical success", %{
      map: map,
      character: character,
      skill1: skill1,
      skill2: skill2,
      character_skill_1: character_skill_1,
      character_skill_2: character_skill_2
    } do
      assert {:ok, chat} =
               Dices.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 3,
                   difficulty: 18
                 },
                 fn _ -> 20 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} + 3 con Diff. 18 ottenendo un successo critico (10 + 20)."
    end

    test "create_dice_throw_chat_entry/2 Returns a failure", %{
      map: map,
      character: character,
      skill1: skill1,
      skill2: skill2,
      character_skill_1: character_skill_1,
      character_skill_2: character_skill_2
    } do
      assert {:ok, chat} =
               Dices.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 3,
                   difficulty: 18
                 },
                 fn _ -> 5 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} + 3 con Diff. 18 ottenendo un fallimento (10 + 5)."
    end

    test "create_dice_throw_chat_entry/2 returns a success", %{
      map: map,
      character: character,
      skill1: skill1,
      skill2: skill2,
      character_skill_1: character_skill_1,
      character_skill_2: character_skill_2
    } do
      assert {:ok, chat} =
               Dices.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 3,
                   difficulty: 10
                 },
                 fn _ -> 5 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} + 3 con Diff. 10 ottenendo un successo (10 + 5)."
    end

    test "create_dice_throw_chat_entry/2 returns a failure for the modifier", %{
      map: map,
      character: character,
      skill1: skill1,
      skill2: skill2,
      character_skill_1: character_skill_1,
      character_skill_2: character_skill_2
    } do
      assert {:ok, chat} =
               Dices.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: -1,
                   difficulty: 18
                 },
                 fn _ -> 7 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} - 1 con Diff. 18 ottenendo un fallimento (6 + 7)."
    end

    test "create_dice_throw_chat_entry/2 returns a success when the result equals the difficulty",
         %{
           map: map,
           character: character,
           skill1: skill1,
           skill2: skill2,
           character_skill_1: character_skill_1,
           character_skill_2: character_skill_2
         } do
      assert {:ok, chat} =
               Dices.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 0,
                   difficulty: 10
                 },
                 fn _ -> 7 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} con Diff. 10 ottenendo un successo (7 + 7)."
    end

    test "create_dice_throw_chat_entry/2 fails because the character is fatigued",
         %{
           map: map,
           character: character,
           skill1: skill1,
           skill2: skill2,
           character_skill_1: character_skill_1,
           character_skill_2: character_skill_2
         } do
      {:ok, character} = Characters.update_character(character, %{fatigue: 100})

      # Adding the skill type
      attribute_skill_type = skill_type_fixture(%{name: "Attribute"})
      skill_skill_type = skill_type_fixture(%{name: "Skill"})

      Skills.add_skill_type_to_skill(skill1, attribute_skill_type)
      Skills.add_skill_type_to_skill(skill2, skill_skill_type)

      assert {:ok, chat} =
               Dices.create_dice_throw_chat_entry(
                 %{
                   character: character,
                   map: map,
                   attribute: character_skill_1,
                   skill: character_skill_2,
                   modifier: 0,
                   difficulty: 12
                 },
                 fn _ -> 7 end
               )

      assert chat.text ==
               "Ha effettuato un tiro di #{skill1.name} + #{skill2.name} con Diff. 12 ottenendo un fallimento (4 + 7)."
    end
  end
end
