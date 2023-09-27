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
end
