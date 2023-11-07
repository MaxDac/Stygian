defmodule Stygian.WeaponsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Weapons` context.
  """

  import Stygian.SkillsFixtures

  @doc """
  Generate a weapon.
  """
  def weapon_fixture(attrs \\ %{}) do
    {:ok, weapon} =
      attrs
      |> check_skill(:required_skill_id)
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        image_url: "some image_url",
        required_skill_min_value: 42,
        damage_bonus: 42,
        cost: 42
      })
      |> Stygian.Weapons.create_weapon()

    weapon
  end
end
