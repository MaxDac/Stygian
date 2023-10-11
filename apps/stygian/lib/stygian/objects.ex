defmodule Stygian.Objects do
  @moduledoc """
  The Objects context.
  """

  import Ecto.Query, warn: false

  alias Stygian.Repo
  alias Stygian.Transactions

  alias Stygian.Characters
  alias Stygian.Objects.CharacterObject
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
  def get_character_object!(id),
    do:
      CharacterObject
      |> preload(:object)
      |> Repo.get!(id)

  @doc """
  Gets a single character_object, preloading the object. Returns nil if the item does not exist.
  """
  @spec get_character_object(id :: non_neg_integer()) :: CharacterObject.t() | nil
  def get_character_object(id) do
    CharacterObject
    |> preload(:object)
    |> Repo.get(id)
  end

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
  Creates more than one connection between a character and an object.
  """
  def create_character_objects(attrs \\ %{})

  def create_character_objects(%{"quantity" => quantity} = attrs) do
    quantity = String.to_integer(quantity)

    1..quantity
    |> Enum.reduce(
      Ecto.Multi.new(),
      fn index, transaction ->
        Ecto.Multi.insert(
          transaction,
          "character_object_#{index}",
          CharacterObject.changeset(%CharacterObject{}, attrs)
        )
      end
    )
    |> Repo.transaction()
  end

  def create_character_objects(attrs), do: create_character_object(attrs)

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

  @doc """
  Returns the list of the character objects.
  """
  def list_character_objects(character_id) do
    CharacterObject
    |> from()
    |> where([co], co.character_id == ^character_id)
    |> preload(:object)
    |> preload(:character)
    |> Repo.all()
  end

  @doc """
  Changes the ownership of an object from one character to the other.
  """
  @spec give_object(
          character_object :: CharacterObject.t(),
          receiver_character_id :: non_neg_integer()
        ) :: {:ok, CharacterObject.t()} | {:error, Ecto.Changeset.t()}
  def give_object(character_object, receiver_character_id) do
    case Characters.get_character(receiver_character_id) do
      nil ->
        {:error, %Ecto.Changeset{}}

      _ ->
        character_object_changeset =
          character_object
          |> CharacterObject.changeset(%{character_id: receiver_character_id})

        object_transaction_changeset =
          Transactions.object_transaction_changeset(%{
            "sender_id" => character_object.character_id,
            "receiver_id" => receiver_character_id,
            "character_object_id" => character_object.id
          })

        Ecto.Multi.new()
        |> Ecto.Multi.update(:character_object, character_object_changeset)
        |> Ecto.Multi.insert(:transaction, object_transaction_changeset)
        |> Repo.transaction()
    end
  end

  alias Stygian.Objects.Effect

  @doc """
  Returns the list of object_effects.

  ## Examples

      iex> list_object_effects()
      [%Effect{}, ...]

  """
  def list_object_effects do
    Effect
    |> from()
    |> preload(:object)
    |> preload(:skill)
    |> Repo.all()
  end

  @doc """
  Lists all the effects for a specific object.
  """
  @spec list_object_effects(object_id :: non_neg_integer()) :: list(Effect.t())
  def list_object_effects(object_id) do
    Effect
    |> from()
    |> where([e], e.object_id == ^object_id)
    |> preload(:object)
    |> preload(:skill)
    |> Repo.all()
  end

  @doc """
  Gets a single effect.

  Raises `Ecto.NoResultsError` if the Effect does not exist.

  ## Examples

      iex> get_effect!(123)
      %Effect{}

      iex> get_effect!(456)
      ** (Ecto.NoResultsError)

  """
  def get_effect!(id), do: Repo.get!(Effect, id)

  @doc """
  Gets a single effect, preloading the object and the skill.
  """
  @spec get_complete_effect(id :: non_neg_integer()) :: Effect.t() | nil
  def get_complete_effect(id) do
    Effect
    |> from()
    |> where([e], e.id == ^id)
    |> preload(:object)
    |> preload(:skill)
    |> Repo.one()
  end

  @doc """
  Creates a effect.

  ## Examples

      iex> create_effect(%{field: value})
      {:ok, %Effect{}}

      iex> create_effect(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_effect(attrs \\ %{}) do
    with {:ok, %{id: saved_effect_id}} <- %Effect{} |> Effect.changeset(attrs) |> Repo.insert() do
      effect = get_complete_effect(saved_effect_id)
      {:ok, effect}
    end
  end

  @doc """
  Updates a effect.

  ## Examples

      iex> update_effect(effect, %{field: new_value})
      {:ok, %Effect{}}

      iex> update_effect(effect, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_effect(%Effect{} = effect, attrs) do
    with {:ok, %{id: saved_effect_id}} <- effect |> Effect.changeset(attrs) |> Repo.update() do
      effect = get_complete_effect(saved_effect_id)
      {:ok, effect}
    end
  end

  @doc """
  Deletes a effect.

  ## Examples

      iex> delete_effect(effect)
      {:ok, %Effect{}}

      iex> delete_effect(effect)
      {:error, %Ecto.Changeset{}}

  """
  def delete_effect(%Effect{} = effect) do
    Repo.delete(effect)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking effect changes.

  ## Examples

      iex> change_effect(effect)
      %Ecto.Changeset{data: %Effect{}}

  """
  def change_effect(%Effect{} = effect, attrs \\ %{}) do
    Effect.changeset(effect, attrs)
  end
end
