defmodule Stygian.Organisations do
  @moduledoc """
  The Organisations context.
  """

  import Ecto.Query, warn: false

  alias Stygian.Repo

  alias Stygian.Characters
  alias Stygian.Characters.Character
  alias Stygian.Organisations.CharactersOrganisations
  alias Stygian.Organisations.Organisation

  @withdraw_time_limit_in_seconds 24 * 60 * 60
  @max_character_fatigue_to_withdraw 80

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
  Gets a single organisation.

  Returns nil if the organisation does not exist.

  ## Examples

      iex> get_organisation!(123)
      %Organisation{}

      iex> get_organisation!(456)
      nil

  """
  @spec get_organisation(id :: non_neg_integer()) :: Organisation.t() | nil
  def get_organisation(id), do: Repo.get(Organisation, id)

  @doc """
  Gets a single organisation by name.
  """
  @spec get_organisation_by_name(organisation_name :: String.t()) :: Organisation.t() | nil
  def get_organisation_by_name(organisation_name) do
    Organisation
    |> from()
    |> where([o], o.name == ^organisation_name)
    |> Repo.one()
  end

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
      [%CharactersOrganisations{}, ...]

  """
  def list_characters_rel_organisations do
    Repo.all(CharactersOrganisations)
  end

  @doc """
  Gets a single characters_organisations.

  Raises `Ecto.NoResultsError` if the Characters organisations does not exist.

  ## Examples

      iex> get_characters_organisations!(123)
      %CharactersOrganisations{}

      iex> get_characters_organisations!(456)
      ** (Ecto.NoResultsError)

  """
  def get_characters_organisations!(id), do: Repo.get!(CharactersOrganisations, id)

  @doc """
  Gets the character job, if any, or nil if the charater has no job.
  """
  @spec get_character_organisation(character_id :: integer) ::
          CharactersOrganisations.t() | nil
  def get_character_organisation(character_id) do
    CharactersOrganisations
    |> from()
    |> where([co], co.character_id == ^character_id and is_nil(co.end_date))
    |> preload(:organisation)
    |> Repo.one()
  end

  @doc """
  Determines whether the character has an organisation.
  """
  @spec has_character_organisation?(character_id :: non_neg_integer()) :: boolean()
  def has_character_organisation?(character_id) do
    CharactersOrganisations
    |> from()
    |> where([co], co.character_id == ^character_id and is_nil(co.end_date))
    |> Repo.exists?()
  end

  @doc """
  Creates a characters_organisations.

  ## Examples

      iex> create_characters_organisations(%{field: value})
      {:ok, %CharactersOrganisations{}}

      iex> create_characters_organisations(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_characters_organisations(attrs \\ %{}) do
    %CharactersOrganisations{}
    |> CharactersOrganisations.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a characters_organisations.

  ## Examples

      iex> update_characters_organisations(characters_organisations, %{field: new_value})
      {:ok, %CharactersOrganisations{}}

      iex> update_characters_organisations(characters_organisations, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_characters_organisations(
        %CharactersOrganisations{} = characters_organisations,
        attrs
      ) do
    characters_organisations
    |> CharactersOrganisations.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Helper method to assign an organisation to a character.
  The association will not take place if the character is already associated with another organisation.
  """
  @spec assign_character_organisation(
          character_id :: non_neg_integer(),
          organisation_id :: non_neg_integer()
        ) ::
          {:ok, CharactersOrganisations.t()} | {:error, String.t()} | {:error, Ecto.Changeset.t()}
  def assign_character_organisation(character_id, organisation_id) do
    with false <- has_character_organisation?(character_id),
         %Character{} = character <- Characters.get_character(character_id),
         %Organisation{} = organisation <- get_organisation(organisation_id) do
      create_characters_organisations(%{
        character_id: character.id,
        organisation_id: organisation.id
      })
    else
      true ->
        {:error, "Il personaggio appartiene già ad un'organizzazione."}

      _ ->
        {:error, "Personaggio o organizzazione inesistenti."}
    end
  end

  @doc """
  Revokes the organisation association from the character.
  """
  @spec revoke_character_organisation(character_id :: non_neg_integer()) ::
          {:ok, CharactersOrganisations.t()} | {:error, String.t()} | {:error, Ecto.Changeset.t()}
  def revoke_character_organisation(character_id) do
    if has_character_organisation?(character_id) do
      get_character_organisation(character_id)
      |> CharactersOrganisations.changeset(%{end_date: NaiveDateTime.utc_now()})
      |> Repo.update()
    else
      {:error, "Il personaggio non appartiene a nessuna organizzazione."}
    end
  end

  @doc """
  Deletes a characters_organisations.

  ## Examples

      iex> delete_characters_organisations(characters_organisations)
      {:ok, %CharactersOrganisations{}}

      iex> delete_characters_organisations(characters_organisations)
      {:error, %Ecto.Changeset{}}

  """
  def delete_characters_organisations(%CharactersOrganisations{} = characters_organisations) do
    Repo.delete(characters_organisations)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking characters_organisations changes.

  ## Examples

      iex> change_characters_organisations(characters_organisations)
      %Ecto.Changeset{data: %CharactersOrganisations{}}

  """
  def change_characters_organisations(
        %CharactersOrganisations{} = characters_organisations,
        attrs \\ %{}
      ) do
    CharactersOrganisations.changeset(characters_organisations, attrs)
  end

  @doc """
  Determines whether the character can withdraw the salary from the organisation for the work done.
  """
  @spec can_withdraw_salary?(character_id :: non_neg_integer()) :: boolean()
  def can_withdraw_salary?(character_id) do
    limit =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(@withdraw_time_limit_in_seconds * -1, :second)

    CharactersOrganisations
    |> from()
    |> where(
      [co],
      co.character_id == ^character_id and co.last_salary_withdraw < ^limit and
        is_nil(co.end_date)
    )
    |> Repo.exists?()
  end

  @doc """
  Allows the character to withdraw the salary from the organisation for the work done.
  The salary can be withdrawn only once per day.
  """
  @spec withdraw_salary(character_id :: non_neg_integer()) ::
          {:ok, CharactersOrganisations.t()} | {:error, String.t()} | {:error, Ecto.Changeset.t()}
  def withdraw_salary(character_id) do
    character = Characters.get_character(character_id)

    case {can_withdraw_salary?(character_id), can_character_work?(character)} do
      {false, _} ->
        {:error, "Non puoi ancora ritirare lo stipendio, devi aspettare un giorno."}

      {_, false} ->
        {:error, "Il personaggio è troppo stanco per lavorare."}

      _ ->
        perform_withdrawal(character)
    end
  end

  defp can_character_work?(%{fatigue: fatigue}) do
    fatigue < @max_character_fatigue_to_withdraw
  end

  defp perform_withdrawal(%{id: character_id, cigs: cigs, fatigue: fatigue} = character) do
    %{organisation: %{base_salary: base_salary, work_fatigue: work_fatigue}} = get_character_organisation(character_id)

    job_changeset =
      get_character_organisation(character_id)
      |> CharactersOrganisations.changeset(%{last_salary_withdraw: NaiveDateTime.utc_now()})

    character_changeset =
      character
      |> Characters.change_character(%{
        cigs: cigs + base_salary,
        fatigue: fatigue + work_fatigue
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(:job, job_changeset)
    |> Ecto.Multi.update(:character, character_changeset)
    |> Repo.transaction()
  end
end
