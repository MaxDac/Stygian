defmodule Stygian.CharacterEffectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Characters` context, only for the 
  character effects.
  """

  import Stygian.CharactersFixtures
  import Stygian.ObjectsFixtures

  @doc """
  Generate a character_effect.
  """
  def character_effect_fixture(attrs \\ %{}) do
    {:ok, character_effect} =
      attrs
      |> check_character()
      |> check_object()
      |> Enum.into(%{})
      |> Stygian.Characters.create_character_effect_test()

    character_effect
  end
end
