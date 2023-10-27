defmodule Stygian.MapsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Maps` context.
  """

  alias Stygian.CharactersFixtures
  alias Stygian.Maps

  @doc """
  Generate a map.
  """
  def map_fixture(attrs \\ %{}) do
    {:ok, map} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image_name: "some image_name",
        name: "some name",
        coords: "10,20,30,40",
        coords_type: "rect"
      })
      |> Stygian.Maps.create_map()

    map
  end

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> CharactersFixtures.check_character()
      |> check_map()
      |> Enum.into(%{
        text: "some text",
        type: :text
      })
      |> Stygian.Maps.create_chat_test()

    chat
  end

  @doc """
  Generates a private chat occupant.
  By passing either map_id or character_id, the fixture will not create a new one.
  """
  def private_map_character_fixture(attrs \\ %{}) do
    attrs =
      if Map.has_key?(attrs, :map_id) do
        attrs
      else
        %{id: map_id} = map_fixture()
        Map.put(attrs, :map_id, map_id)
      end

    attrs =
      if Map.has_key?(attrs, :character_id) do
        attrs
      else
        %{id: character_id} = CharactersFixtures.character_fixture()
        Map.put(attrs, :character_id, character_id)
      end

    {:ok, private_map_character} = Maps.create_private_map_character(attrs)
    private_map_character
  end

  @doc """
  Checks whether the map exists in the attribute map or not. 
  """
  def check_map(%{map_id: _} = attrs), do: attrs

  def check_map(attrs) do
    %{id: map_id} = map_fixture()
    Map.put(attrs, :map_id, map_id)
  end
end
