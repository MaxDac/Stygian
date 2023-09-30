defmodule Stygian.ObjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Objects` context.
  """

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
        usages: 42
      })
      |> Stygian.Objects.create_object()

    object
  end

  import Stygian.CharactersFixtures

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

  defp check_character(%{character_id: _} = attrs), do: attrs

  defp check_character(attrs) do
    character = character_fixture()
    Map.put(attrs, :character_id, character.id)
  end

  defp check_object(%{object_id: _} = attrs), do: attrs

  defp check_object(attrs) do
    object = object_fixture()
    Map.put(attrs, :object_id, object.id)
  end
end
