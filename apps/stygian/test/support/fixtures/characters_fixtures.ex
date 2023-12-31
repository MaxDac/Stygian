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
        age: :adult,
        sin: "some awful sin",
        lost_health: 1,
        lost_sanity: 1,
        fatigue: 42,
        npc: false,
        # notes: "some notes",
        # sanity: 42,
        step: 1,
        user_id: user_id
      })
      |> Stygian.Characters.create_character()

    character
  end

  @doc """
  Generate a character with a complete set of entries.
  """
  def character_fixture_complete(attrs \\ %{}) do
    # Creating the user first as it's a mandatory field for the character.
    %{id: user_id} = user_fixture()

    attrs =
      attrs
      |> Enum.into(%{
        admin_notes: "some admin_notes",
        avatar: "some avatar",
        biography: "some biography",
        cigs: 42,
        description: "some description",
        experience: 42,
        health: 42,
        name: "some awful name",
        age: :adult,
        sin: "some awful sin",
        lost_health: 1,
        lost_sanity: 1,
        npc: false,
        notes: "some notes",
        sanity: 42,
        step: 1,
        fatigue: 42,
        user_id: user_id
      })

    {:ok, character} =
      attrs
      |> Stygian.Characters.create_character()

    {:ok, character} =
      character
      |> Stygian.Characters.update_character(attrs)

    character
  end

  @doc """
  Generate a character_skill.
  """
  def character_skill_fixture(attrs \\ %{}) do
    {:ok, character_skill} =
      attrs
      |> check_character()
      |> check_skill()
      |> Enum.into(%{
        value: 42
      })
      |> Stygian.Characters.create_character_skill()

    character_skill
  end

  @doc """
  Checks whether the character exists in the attribute map or not. 
  """
  def check_character(attrs, key \\ :character_id, name \\ "some_character_name") do
    case Map.has_key?(attrs, key) do
      true ->
        attrs

      false ->
        %{id: character_id} = character_fixture(%{name: name})
        Map.put(attrs, key, character_id)
    end
  end
end
