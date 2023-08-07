defmodule Stygian.MapsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Maps` context.
  """

  alias Stygian.CharactersFixtures

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
    map = map_fixture()
    character = CharactersFixtures.character_fixture()

    {:ok, chat} =
      attrs
      |> Enum.into(%{
        text: "some text",
        type: :text,
        character_id: character.id,
        map_id: map.id
      })
      |> Stygian.Maps.create_chat()

    chat
  end
end
