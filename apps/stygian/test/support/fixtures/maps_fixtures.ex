defmodule Stygian.MapsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Maps` context.
  """

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
end
