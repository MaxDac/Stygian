defmodule Stygian.OrganisationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Organisations` context.
  """

  @doc """
  Generate a organisation.
  """
  def organisation_fixture(attrs \\ %{}) do
    {:ok, organisation} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        image: "some image",
        base_salary: 42
      })
      |> Stygian.Organisations.create_organisation()

    organisation
  end
end
