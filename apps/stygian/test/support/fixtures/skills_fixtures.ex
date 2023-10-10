defmodule Stygian.SkillsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Skills` context.
  """

  def unique_skill_name, do: "skill#{System.unique_integer()}"

  @doc """
  Generate a skill_type.
  """
  def skill_type_fixture(attrs \\ %{}) do
    {:ok, skill_type} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Stygian.Skills.create_skill_type()

    skill_type
  end

  @doc """
  Generate a skill.
  """
  def skill_fixture(attrs \\ %{}) do
    {:ok, skill} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: unique_skill_name()
      })
      |> Stygian.Skills.create_skill()

    skill
  end

  def check_skill(%{skill_id: _} = attrs), do: attrs

  def check_skill(attrs) do
    skill = skill_fixture()
    Map.put(attrs, :skill_id, skill.id)
  end
end
