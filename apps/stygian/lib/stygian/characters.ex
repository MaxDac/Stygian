defmodule Stygian.Characters do
  @moduledoc """
  The Characters context.
  """

  import Ecto.Query, warn: false
  alias Stygian.Repo

  alias Stygian.Characters.Character
  alias Stygian.Characters.CharacterSkill

  @doc """
  Returns the list of characters.

  ## Examples

      iex> list_characters()
      [%Character{}, ...]

  """
  def list_characters do
    Repo.all(Character)
  end

  @doc """
  Gets a single character.

  Raises `Ecto.NoResultsError` if the Character does not exist.

  ## Examples

      iex> get_character!(123)
      %Character{}

      iex> get_character!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character!(id), do: Repo.get!(Character, id)

  @doc """
  Creates a character.

  ## Examples

      iex> create_character(%{field: value})
      {:ok, %Character{}}

      iex> create_character(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_character(attrs = %{"user_id" => user_id}) do
    create_character_internal(attrs, user_id)
  end

  def create_character(attrs = %{user_id: user_id}) do
    create_character_internal(attrs, user_id)
  end

  def create_character(_) do
    {:error, Ecto.Changeset.add_error(%Ecto.Changeset{}, :user_id, "is required")}
  end

  defp create_character_internal(attrs, user_id) do
    case user_has_character?(user_id) do
      false ->
        attrs = add_step_to_character_attrs(attrs, 1)

        %Character{}
        |> Character.name_avatar_changeset(attrs)
        |> Repo.insert()

      _ ->
        {:error, Ecto.Changeset.add_error(%Ecto.Changeset{}, :user_id, "already has a character")}
    end
  end

  defp user_has_character?(user_id) do
    Character
    |> from()
    |> where([c], c.user_id == ^user_id)
    |> Repo.exists?()
  end

  @doc """
  Completes the character creation by adding its attributes and updating the character step to 2.
  """
  @spec complete_character(Character.t(), [map()]) :: Character.t()
  def complete_character(character, attributes) do
    attrs = add_step_to_character_attrs(%{}, 2)

    for attribute <- attributes do
      character_skill = CharacterSkill.changeset(%CharacterSkill{}, attribute)
      Repo.insert!(character_skill)
    end

    character
    |> Character.update_step_changeset(attrs)
    |> Repo.update()
  end

  defp add_step_to_character_attrs(attrs, step) do
    case {Map.has_key?(attrs, :step), Map.has_key?(attrs, "step"), Map.keys(attrs)} do
      {false, true, _} ->
        attrs

      {true, false, _} ->
        attrs

      {_, _, [k | _]} when is_atom(k) ->
        Map.put(attrs, :step, step)

      _ ->
        Map.put(attrs, "step", step)
    end
  end

  @doc """
  Determines whether a user has already a completed character.
  """
  @spec user_has_complete_charater?(User.t()) :: boolean()
  def user_has_complete_charater?(user) do
    character = get_user_character?(user)
    character.step == 2
  end

  @doc """
  Updates a character.

  ## Examples

      iex> update_character(character, %{field: new_value})
      {:ok, %Character{}}

      iex> update_character(character, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a character.

  ## Examples

      iex> delete_character(character)
      {:ok, %Character{}}

      iex> delete_character(character)
      {:error, %Ecto.Changeset{}}

  """
  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  @doc """
  Returns the user's character if existent, nil otherwise.
  """
  @spec get_user_character?(User.t()) :: Character.t() | nil
  def get_user_character?(user) do
    Character
    |> from()
    |> where([c], c.user_id == ^user.id)
    |> Repo.one()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character changes.

  ## Examples

      iex> change_character(character)
      %Ecto.Changeset{data: %Character{}}

  """
  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking the name and the avatar.

  ## Examples

      iex> change_character_name_and_avatar(character)
      %Ecto.Changeset{data: %Character{}}

  """
  def change_character_name_and_avatar(%Character{} = character, attrs \\ %{}) do
    Character.name_avatar_changeset(character, attrs)
  end

  alias Stygian.Characters.CharacterSkill

  @doc """
  Returns the list of character_skills.

  ## Examples

      iex> list_character_skills()
      [%CharacterSkill{}, ...]

  """
  def list_character_skills(character) do
    CharacterSkill
    |> from()
    |> where([cs], cs.character_id == ^character.id)
    |> preload(:skill)
    |> Repo.all()
  end

  @doc """
  Gets a single character_skill.

  Raises `Ecto.NoResultsError` if the Character skill does not exist.

  ## Examples

      iex> get_character_skill!(123)
      %CharacterSkill{}

      iex> get_character_skill!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character_skill!(id), do: Repo.get!(CharacterSkill, id)

  @doc """
  Creates a character_skill.

  ## Examples

      iex> create_character_skill(%{field: value})
      {:ok, %CharacterSkill{}}

      iex> create_character_skill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_character_skill(attrs \\ %{}) do
    %CharacterSkill{}
    |> CharacterSkill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a character_skill.

  ## Examples

      iex> update_character_skill(character_skill, %{field: new_value})
      {:ok, %CharacterSkill{}}

      iex> update_character_skill(character_skill, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_character_skill(%CharacterSkill{} = character_skill, attrs) do
    character_skill
    |> CharacterSkill.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a character_skill.

  ## Examples

      iex> delete_character_skill(character_skill)
      {:ok, %CharacterSkill{}}

      iex> delete_character_skill(character_skill)
      {:error, %Ecto.Changeset{}}

  """
  def delete_character_skill(%CharacterSkill{} = character_skill) do
    Repo.delete(character_skill)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character_skill changes.

  ## Examples

      iex> change_character_skill(character_skill)
      %Ecto.Changeset{data: %CharacterSkill{}}

  """
  def change_character_skill(%CharacterSkill{} = character_skill, attrs \\ %{}) do
    CharacterSkill.changeset(character_skill, attrs)
  end
end
