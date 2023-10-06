defmodule Stygian.OrganisationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stygian.Organisations` context.
  """

  import Stygian.CharactersFixtures

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

  @doc """
  Generate a charcters_organisations.
  """
  def charcters_organisations_fixture(attrs \\ %{}) do
    %{id: character_id} = character_fixture()
    %{id: organisation_id} = organisation_fixture()

    {:ok, charcters_organisations} =
      attrs
      |> Enum.into(%{
        character_id: character_id,
        organisation_id: organisation_id,
        last_salary_withdraw: ~N[2023-10-04 20:46:00]
      })
      |> Stygian.Organisations.create_charcters_organisations()

    charcters_organisations
  end
end
