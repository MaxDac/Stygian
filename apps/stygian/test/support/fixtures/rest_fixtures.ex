defmodule Stygian.RestFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Rest` context.
  """

  @doc """
  Generate a rest_action.
  """
  def rest_action_fixture(attrs \\ %{}) do
    {:ok, rest_action} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        health: 42,
        sanity: 42,
        research_points: 42,
        slots: 1
      })
      |> Stygian.Rest.create_rest_action()

    rest_action
  end
end
