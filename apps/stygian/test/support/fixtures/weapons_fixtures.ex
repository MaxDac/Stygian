defmodule Stygian.WeaponsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Weapons` context.
  """

  import Stygian.SkillsFixtures
  import Stygian.CharactersFixtures

  alias Stygian.Weapons.CharacterWeapons

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

  @doc """
  Generates a relation record between a character and a weapon.
  """
  def character_weapon_fixture(attrs \\ %{}) do
    attrs =
      attrs
      |> check_character()
      |> check_weapon()

    {:ok, character_weapon} =
      %CharacterWeapons{}
      |> CharacterWeapons.changeset(attrs)
      |> Stygian.Repo.insert()

    character_weapon
  end

  def check_weapon(%{weapon_id: _} = attrs), do: attrs

  def check_weapon(attrs) do
    %{id: weapon_id} = weapon_fixture()
    Map.put(attrs, :weapon_id, weapon_id)
  end
end
