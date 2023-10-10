defmodule Stygian.ObjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Objects` context.
  """

  import Stygian.CharactersFixtures
  import Stygian.SkillsFixtures

  @doc """
  Generate a object.
  """
  def object_fixture(attrs \\ %{}) do
    {:ok, object} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image_url: "some image_url",
        name: "some name",
        usages: 42,
        health: 0,
        sanity: 0
      })
      |> Stygian.Objects.create_object()

    object
  end

  @doc """
  Generate a character_object.
  """
  def character_object_fixture(attrs \\ %{}) do
    {:ok, character_object} =
      attrs
      |> check_character()
      |> check_object()
      |> Enum.into(%{
        usages: 42
      })
      |> Stygian.Objects.create_character_object()

    character_object
  end

  @doc """
  Generate a effect.
  """
  def effect_fixture(attrs \\ %{}) do
    {:ok, effect} =
      attrs
      |> check_object()
      |> check_skill()
      |> Enum.into(%{
        value: 42
      })
      |> Stygian.Objects.create_effect()

    effect
  end

  def strip_effects_fk(effect) do
    effect
    |> Map.delete(:object)
    |> Map.delete(:skill)
  end

  def check_object(%{object_id: _} = attrs), do: attrs

  def check_object(attrs) do
    object = object_fixture()
    Map.put(attrs, :object_id, object.id)
  end
end
