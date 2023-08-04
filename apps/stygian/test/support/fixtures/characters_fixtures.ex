defmodule Stygian.CharactersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Characters` context.
  """

  import Stygian.AccountsFixtures
  import Stygian.SkillsFixtures

  @doc """
  Generate a character.
  """
  def character_fixture(attrs \\ %{}) do
    # Creating the user first as it's a mandatory field for the character.
    %{id: user_id} = user_fixture()

    {:ok, character} =
      attrs
      |> Enum.into(%{
        # admin_notes: "some admin_notes",
        avatar: "some avatar",
        # biography: "some biography",
        # cigs: 42,
        # description: "some description",
        # experience: 42,
        # health: 42,
        name: "some awful name",
        # notes: "some notes",
        # sanity: 42,
        step: 1,
        user_id: user_id
      })
      |> Stygian.Characters.create_character()

    character
  end

  @doc """
  Generate a character_skill.
  """
  def character_skill_fixture(attrs \\ %{}) do
    # Adding the character and skill for FK constraints.
    %{id: character_id} = character_fixture()
    %{id: skill_id} = skill_fixture()

    {:ok, character_skill} =
      attrs
      |> Enum.into(%{
        value: 42,
        character_id: character_id,
        skill_id: skill_id
      })
      |> Stygian.Characters.create_character_skill()

    character_skill
  end
end
