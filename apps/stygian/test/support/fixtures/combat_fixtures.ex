defmodule Stygian.CombatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Combat` context.
  """

  import Stygian.SkillsFixtures

  @doc """
  Generate a weapon_type.
  """
  def weapon_type_fixture(attrs \\ %{}) do
    {:ok, weapon_type} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description"
      })
      |> Stygian.Combat.create_weapon_type()

    weapon_type
  end

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

  def check_weapon_type(%{weapon_type_id: _} = attrs), do: attrs

  def check_weapon_type(attrs) do
    weapon_type = weapon_type_fixture()
    Map.put(attrs, :weapon_type_id, weapon_type.id)
  end
end
