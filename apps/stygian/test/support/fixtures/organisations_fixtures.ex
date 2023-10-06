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
  Generate a characters_organisations.
  """
  def characters_organisations_fixture(attrs \\ %{}) do
    {:ok, characters_organisations} =
      attrs
      |> add_character_fixture()
      |> add_organisation_fixture()
      |> Enum.into(%{
        last_salary_withdraw: ~N[2023-10-04 20:46:00]
      })
      |> Stygian.Organisations.create_characters_organisations()

    characters_organisations
  end

  defp add_character_fixture(%{character_id: _} = attrs), do: attrs

  defp add_character_fixture(attrs) do
    %{id: character_id} = character_fixture()
    Map.put(attrs, :character_id, character_id)
  end

  defp add_organisation_fixture(%{organisation_id: _} = attrs), do: attrs

  defp add_organisation_fixture(attrs) do
    %{id: organisation_id} = organisation_fixture()
    Map.put(attrs, :organisation_id, organisation_id)
  end
end
