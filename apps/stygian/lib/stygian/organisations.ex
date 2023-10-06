defmodule Stygian.Organisations do
  @moduledoc """
  The Organisations context.
  """

  import Ecto.Query, warn: false
  alias Stygian.Repo

  alias Stygian.Organisations.Organisation
  alias Stygian.Organisations.CharctersOrganisations

  @doc """
  Returns the list of organisations.

  ## Examples

      iex> list_organisations()
      [%Organisation{}, ...]

  """
  def list_organisations do
    Repo.all(Organisation)
  end

  @doc """
  Gets a single organisation.

  Raises `Ecto.NoResultsError` if the Organisation does not exist.

  ## Examples

      iex> get_organisation!(123)
      %Organisation{}

      iex> get_organisation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organisation!(id), do: Repo.get!(Organisation, id)

  @doc """
  Creates a organisation.

  ## Examples

      iex> create_organisation(%{field: value})
      {:ok, %Organisation{}}

      iex> create_organisation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organisation(attrs \\ %{}) do
    %Organisation{}
    |> Organisation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organisation.

  ## Examples

      iex> update_organisation(organisation, %{field: new_value})
      {:ok, %Organisation{}}

      iex> update_organisation(organisation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organisation(%Organisation{} = organisation, attrs) do
    organisation
    |> Organisation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a organisation.

  ## Examples

      iex> delete_organisation(organisation)
      {:ok, %Organisation{}}

      iex> delete_organisation(organisation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organisation(%Organisation{} = organisation) do
    Repo.delete(organisation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organisation changes.

  ## Examples

      iex> change_organisation(organisation)
      %Ecto.Changeset{data: %Organisation{}}

  """
  def change_organisation(%Organisation{} = organisation, attrs \\ %{}) do
    Organisation.changeset(organisation, attrs)
  end

  @doc """
  Returns the list of characters_rel_organisations.

  ## Examples

      iex> list_characters_rel_organisations()
      [%CharctersOrganisations{}, ...]

  """
  def list_characters_rel_organisations do
    Repo.all(CharctersOrganisations)
  end

  @doc """
  Gets a single charcters_organisations.

  Raises `Ecto.NoResultsError` if the Charcters organisations does not exist.

  ## Examples

      iex> get_charcters_organisations!(123)
      %CharctersOrganisations{}

      iex> get_charcters_organisations!(456)
      ** (Ecto.NoResultsError)

  """
  def get_charcters_organisations!(id), do: Repo.get!(CharctersOrganisations, id)

  @doc """
  Gets the character job, if any, or nil if the charater has no job.
  """
  @spec get_character_organisation(character_id :: integer, organisation_id :: integer) ::
          CharctersOrganisations.t() | nil
  def get_character_organisation(character_id, organisation_id) do
    CharctersOrganisations
    |> from()
    |> where([co], co.character_id == ^character_id and co.organisation_id == ^organisation_id)
    |> Repo.one()
  end

  @doc """
  Determines whether the character has an organisation.
  """
  @spec has_character_organisation?(character_id :: non_neg_integer()) :: boolean()
  def has_character_organisation?(character_id) do
    CharctersOrganisations
    |> from()
    |> where([co], co.character_id == ^character_id)
    |> Repo.exists?()
  end

  @doc """
  Creates a charcters_organisations.

  ## Examples

      iex> create_charcters_organisations(%{field: value})
      {:ok, %CharctersOrganisations{}}

      iex> create_charcters_organisations(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_charcters_organisations(attrs \\ %{}) do
    %CharctersOrganisations{}
    |> CharctersOrganisations.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a charcters_organisations.

  ## Examples

      iex> update_charcters_organisations(charcters_organisations, %{field: new_value})
      {:ok, %CharctersOrganisations{}}

      iex> update_charcters_organisations(charcters_organisations, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_charcters_organisations(%CharctersOrganisations{} = charcters_organisations, attrs) do
    charcters_organisations
    |> CharctersOrganisations.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a charcters_organisations.

  ## Examples

      iex> delete_charcters_organisations(charcters_organisations)
      {:ok, %CharctersOrganisations{}}

      iex> delete_charcters_organisations(charcters_organisations)
      {:error, %Ecto.Changeset{}}

  """
  def delete_charcters_organisations(%CharctersOrganisations{} = charcters_organisations) do
    Repo.delete(charcters_organisations)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking charcters_organisations changes.

  ## Examples

      iex> change_charcters_organisations(charcters_organisations)
      %Ecto.Changeset{data: %CharctersOrganisations{}}

  """
  def change_charcters_organisations(
        %CharctersOrganisations{} = charcters_organisations,
        attrs \\ %{}
      ) do
    CharctersOrganisations.changeset(charcters_organisations, attrs)
  end
end
