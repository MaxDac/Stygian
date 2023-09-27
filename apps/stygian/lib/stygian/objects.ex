defmodule Stygian.Objects do
  @moduledoc """
  The Objects context.
  """

  import Ecto.Query, warn: false
  alias Stygian.Repo

  alias Stygian.Objects.Object

  @doc """
  Returns the list of objects.

  ## Examples

      iex> list_objects()
      [%Object{}, ...]

  """
  def list_objects do
    Repo.all(Object)
  end

  @doc """
  Gets a single object.

  Raises `Ecto.NoResultsError` if the Object does not exist.

  ## Examples

      iex> get_object!(123)
      %Object{}

      iex> get_object!(456)
      ** (Ecto.NoResultsError)

  """
  def get_object!(id), do: Repo.get!(Object, id)

  @doc """
  Creates a object.

  ## Examples

      iex> create_object(%{field: value})
      {:ok, %Object{}}

      iex> create_object(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_object(attrs \\ %{}) do
    %Object{}
    |> Object.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a object.

  ## Examples

      iex> update_object(object, %{field: new_value})
      {:ok, %Object{}}

      iex> update_object(object, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_object(%Object{} = object, attrs) do
    object
    |> Object.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a object.

  ## Examples

      iex> delete_object(object)
      {:ok, %Object{}}

      iex> delete_object(object)
      {:error, %Ecto.Changeset{}}

  """
  def delete_object(%Object{} = object) do
    Repo.delete(object)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking object changes.

  ## Examples

      iex> change_object(object)
      %Ecto.Changeset{data: %Object{}}

  """
  def change_object(%Object{} = object, attrs \\ %{}) do
    Object.changeset(object, attrs)
  end

  alias Stygian.Objects.CharacterObject

  @doc """
  Returns the list of characters_rel_objects.

  ## Examples

      iex> list_characters_rel_objects()
      [%CharacterObject{}, ...]

  """
  def list_characters_rel_objects do
    Repo.all(CharacterObject)
  end

  @doc """
  Gets a single character_object.

  Raises `Ecto.NoResultsError` if the Character object does not exist.

  ## Examples

      iex> get_character_object!(123)
      %CharacterObject{}

      iex> get_character_object!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character_object!(id), do: Repo.get!(CharacterObject, id)

  @doc """
  Creates a character_object.

  ## Examples

      iex> create_character_object(%{field: value})
      {:ok, %CharacterObject{}}

      iex> create_character_object(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_character_object(attrs \\ %{}) do
    %CharacterObject{}
    |> CharacterObject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a character_object.

  ## Examples

      iex> update_character_object(character_object, %{field: new_value})
      {:ok, %CharacterObject{}}

      iex> update_character_object(character_object, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_character_object(%CharacterObject{} = character_object, attrs) do
    character_object
    |> CharacterObject.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a character_object.

  ## Examples

      iex> delete_character_object(character_object)
      {:ok, %CharacterObject{}}

      iex> delete_character_object(character_object)
      {:error, %Ecto.Changeset{}}

  """
  def delete_character_object(%CharacterObject{} = character_object) do
    Repo.delete(character_object)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character_object changes.

  ## Examples

      iex> change_character_object(character_object)
      %Ecto.Changeset{data: %CharacterObject{}}

  """
  def change_character_object(%CharacterObject{} = character_object, attrs \\ %{}) do
    CharacterObject.changeset(character_object, attrs)
  end
end
