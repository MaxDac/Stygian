defmodule Stygian.CombatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Combat` context.
  """

  import Stygian.CharactersFixtures
  import Stygian.SkillsFixtures
  import Stygian.WeaponsFixtures

  @doc """
  Generate a action.
  """
  def action_fixture(attrs \\ %{}) do
    {:ok, action} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        minimum_skill_value: 42
      })
      |> check_skill(:attack_attribute_id, "attack_attribute")
      |> check_skill(:attack_skill_id, "attack_skill")
      |> check_skill(:defence_attribute_id, "defence_attribute")
      |> check_skill(:defence_skill_id, "defence_skill")
      |> check_weapon_type()
      |> Stygian.Combat.create_action()

    action
  end

  @doc """
  Generate a chat_action.
  """
  def chat_action_fixture(attrs \\ %{}) do
    {:ok, chat_action} =
      attrs
      |> Enum.into(%{
        resolved: true,
        accepted: true
      })
      |> check_action()
      |> check_character(:attacker_id, "attacker")
      |> check_character(:defender_id, "defender")
      |> Stygian.Combat.create_chat_action()

    chat_action
  end

  def check_action(%{action_id: _} = attrs), do: attrs

  def check_action(attrs) do
    action = action_fixture()
    Map.put(attrs, :action_id, action.id)
  end
end
